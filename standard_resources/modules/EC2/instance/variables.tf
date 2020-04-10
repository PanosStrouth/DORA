variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "user_data_script" {
  type = string
  default = "bootstraping.sh" 
}

variable "instance_profile" {
  type = string
  default = null
}

variable "instance_tag_name" {
  type = string
  default = "HelloWorld"
}
