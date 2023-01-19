// Search ----------------------------------------------------------------------

var fuse;

$(function () {
  // Initialise search index on focus
  $("#search").focus(async function(e) {
    if (fuse) {
      return;
    }

    $(e.target).addClass("loading");

    var response = await fetch('search.json');
    var data = await response.json();

    var options = {
      keys: ["heading", "text", "code"],
      ignoreLocation: true,
      threshold: 0.1,
      includeMatches: true,
      includeScore: true,
    };
    fuse = new Fuse(data, options);

    $(e.target).removeClass("loading");
  });

  // Use algolia autocomplete
  var options = {
    autoselect: true,
    debug: true,
    hint: false,
    minLength: 2,
  };

  $("#search").autocomplete(options, [
    {
      name: "content",
      source: searchFuse,
      templates: {
        suggestion: (s) => {
          if (s.chapter == s.heading) {
            return `${s.chapter}`;
          } else {
            return `${s.chapter} /<br> ${s.heading}`;
          }
        },
      },
    },
  ]).on('autocomplete:selected', function(event, s) {
    window.location.href = s.path + "?q=" + q + "#" + s.id;
  });
});

var q;
async function searchFuse(query, callback) {
  await fuse;

  var items;
  if (!fuse) {
    items = [];
  } else {
    q = query;
    var results = fuse.search(query, { limit: 20 });
    items = results
      .filter((x) => x.score <= 0.75)
      .map((x) => x.item);
  }

  callback(items);
}