# The bootstrap key is for use to provision the machine so far as it can talk to
# the Salt master, but then will be removed.
resource digitalocean_ssh_key "bootstrap" {
  name = "Ephemeral Bootstrap Key"

  # This path is relative to the current working directory:
  public_key = "${file("../keys/ephemeral_id_rsa.pub")}"
}
