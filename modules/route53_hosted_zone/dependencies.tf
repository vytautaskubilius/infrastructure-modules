locals {
  common_tags = merge({
    environment = var.environment
    }, {
    project = var.project
    },
  var.tags)
}
