args <- commandArgs(trailingOnly = TRUE)
# cat("\nargs:\n")
# str(args)

if (length(args) == 0) {
  stop("No args supplied to Rscript. ")
}

image_path <- args[1]
repo_path <- args[2]

if (!nzchar(image_path) && !nzchar(repo_path)) {
  stop("At least one of `image-path` or `repo-path` should be `true`.")
}

packages <- args[3]
strip <- args[4]

packages <- strsplit(packages, "[[:space:],]+")[[1]]
strip <- strsplit(strip, "[[:space:],]+")[[1]]
if (is.character(strip) && length(strip) == 1 && strip == "NULL") strip <- NULL

cat("\nArgs:\n")
str(list(image_path = image_path, repo_path = repo_path, packages = packages, strip = strip))

getwd()
list.files()

# If GITHUB_PAT isn't found, use GITHUB_TOKEN
token <- Sys.getenv("GITHUB_PAT", Sys.getenv("GITHUB_TOKEN"))
Sys.setenv(GITHUB_PAT = token)

# Install rwasm (after PAT is set)
pak::pak(c("r-wasm/rwasm"))

message("\n\nAdding packages:\n", paste("* ", packages, sep = "", collapse = "\n"))
rwasm::add_pkg(packages, repo_dir = repo_path)

message("\n\nMaking library")
rwasm::make_vfs_library(out_dir = image_path, repo_dir = repo_path, strip = strip)
