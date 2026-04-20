terraform {
  # Das Backend bleibt absichtlich ohne feste Werte.
  # Der State-Bucket wird im separaten bootstrap-Setup erzeugt und
  # anschliessend per -backend-config an terraform init uebergeben.
  backend "gcs" {
  }
}
