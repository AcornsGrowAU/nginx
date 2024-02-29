variable "GITHUB_RUN_NUMBER" {
  default = null
}

group "default" {
  targets = [
    "nginx"
  ]
}

target "nginx" {
  pull = true
  tags = [
    "acornsaustralia/nginx:latest",
    GITHUB_RUN_NUMBER != null ? "acornsaustralia/nginx:${GITHUB_RUN_NUMBER}" : ""
  ]
  platforms = [
    "linux/amd64"
  ]
  args = {
    "ROCKY_VERSION" = "9"
  }
}
