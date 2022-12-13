resource "local_file" "foo" {
    content  = "foo"
    filename = "../loaders/example.py"
}


output "yaml" {
    value = local.config
}