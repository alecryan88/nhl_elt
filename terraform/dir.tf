resource "local_file" "foo" {
    for_each = local.loader_names
    content  = ""
    filename = "../loaders/${each.value}/Dockerfile"
}


output "yaml" {
    value = local.config
}