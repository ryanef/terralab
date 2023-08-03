terraform {
  cloud {
    organization = "tfjenkins"

    workspaces {
      name = "terralab"
    }
  }
}