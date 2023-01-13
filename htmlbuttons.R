
library(stringr)
library(dplyr)

# html buttons ------------------------------------------------------------
group <- c(rep("create", 6), rep("manipulate", 7), rep("analyse", 4), rep("visualize", 8), rep("predict", 3))
page <- c("create_logs",
		  "adjust_logs",
		  "public_logs",
		  "xes_files",
		  "metadata",
		  "data_quality",
		  "case_filters",
		  "event_filters",
		  "generic_filtering",
		  "augment",
		  "mutate",
		  "collapse",
		  "unite",
		  "control_flow_analysis",
		  "performance_analysis",
		  "organisational_analysis",
		  "multi_dimensional_analysis",
		  "frequency_maps",
		  "performance_maps",
		  "advanced_maps",
		  "animate_maps",
		  "process_matrix",
		  "dotted_chart",
		  "trace_explorer",
		  "performance_spectrum",
		  "predict_workflow",
		  "predict_adapt",
		  "predict_keras")


page_html <- purrr::map_chr(page, paste0, ".html")
group_page <- data.frame(group, page_html, page) %>%
	mutate(page = str_to_title(str_replace_all(page, "_", " ")))




colors <- data.frame(group = c("install", "create", "manipulate", "analyse", "visualize", "predict"),
					 class = c("primary", "secondary", "info", "danger", "success", "warning"))

# data
df <- dplyr::left_join(group_page, colors)


# functies
find_page_index <- function(df, input_page_html) {
	which(input_page_html == df$page_html)
}

find_not_disabled <- function(df, input_page_html) {
	i <- find_page_index(df, input_page_html)
	groupname <- df$group[i]
	all_grouppages <- df %>% filter(groupname == df$group)
	not_disabled <- all_grouppages %>% filter(input_page_html != page_html)
	list(all_grouppages=all_grouppages, not_disabled=not_disabled)
}

is_disabled <- function(not_disabled, current_page) {
	if(!(current_page %in% not_disabled$page_html))  paste0(" disabled")
}

create_buttons <- function(df, input_page_html = "create_logs.html") {
	disabled <- find_page_index(df, input_page_html)
	not_disabled <- find_not_disabled(df, input_page_html)
	groups <- not_disabled$all_grouppages
	not_disabled <- not_disabled$not_disabled

	cat(
		cat(
			paste0("<div class=\"btn-toolbar\" role=\"group\">", "\n")),


		for (i in 1:nrow(groups)) {
			cat(
				paste0("<a href = \"", groups$page_html[i], "\" class=\"btn btn-", unique(groups$class), is_disabled(not_disabled, groups$page_html[i]), "\" type=\"button\">", groups$page[[i]], "</a>", "\n")
			)
		},
		cat("</div>")
	)


	# cat(
	# 	cat(
	# 		paste0("<div class=\"btn-toolbar\" role=\"group\">", "\n",
	# 			   "<a href = \"", input_page_html, "\" class=\"btn btn-", df$class[[disabled]], " disabled\" type=\"button\">", df$page[[disabled]], "</a>", "\n")),
	# 	for (i in 1:nrow(not_disabled)+1) {
	# 		cat(
	# 			paste0("<a href = \"", not_disabled$page_html[i], "\" class=\"btn btn-", not_disabled$class[[disabled]], "\" type=\"button\">", not_disabled$page[[i]], "</a>", "\n",
	# 				   "</div>")
	# 		)
	# 	}
	# )
}
# create_buttons(df, input_page_html = "create_logs.html")
# create_buttons(df, input_page_html = "adjust_logs.html")
#find_colorclass_index("create_logs.html")


	# <div class="btn-toolbar" role="group">
	# 	<a href = "create_logs.html" class="btn btn-secondary disabled" type="button">Create logs</a>
	# 		<a href = "adjust_logs.html" class="btn btn-secondary" type="button">Adjust logs</a>
	# 			<a href = "public_logs.html" class="btn btn-secondary" type="button">Public logs</a>
	# 				</div>









