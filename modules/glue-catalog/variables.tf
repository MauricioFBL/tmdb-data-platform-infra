variable "layer" {
    type = string
    description = "Contains the name of the layer that will have the glue catalog."
}

variable "environment" {
    type = string
    description = "Environment name (dev, prod)"
    default = "dev"
}