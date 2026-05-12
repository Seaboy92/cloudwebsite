# Terraform für Cloud-Website

Dieses Repository ist in zwei Terraform-Phasen aufgeteilt:

1. `bootstrap/`
   Erstellt ein neues GCP-Projekt, aktiviert benötigte APIs, legt den
   Remote-State-Bucket an und erzeugt den Terraform-Service-Account.
2. `enviroments/dev/`
   Erstellt die eigentliche Infrastruktur fuer die statische Website.
   (Ordner prod kann für spätere Nutzung angelegt werden)

## Warum zwei Phasen?

Terraform kann das `gcs`-Backend erst verwenden, wenn der State-Bucket bereits
existiert. Deshalb wird der Bucket zunächst im Ordner `bootstrap/` mit lokalem
State angelegt. Anschließend verwendet `enviroments/dev/` genau diesen Bucket
als Remote-State.

## 1. Bootstrap ausführen

1. Falls vorhanden, eine alte lokale State-Datei im Ordner `IaC-Terraform/bootstrap`
   entfernen:

   ```powershell
   Remove-Item .\terraform.tfstate, .\terraform.tfstate.backup -ErrorAction SilentlyContinue
   ```

2. Lokal bei Google Cloud mit Application Default Credentials anmelden:

   ```powershell
   gcloud auth application-default login
   ```

3. In `IaC-Terraform/bootstrap/terraform.tfvars` die benötigten Werte anpassen (.example als Grundlage):

- `project_id`: neue weltweit eindeutige GCP-Projekt-ID
- `project_name`: Anzeigename des Projekts
- `billing_account`: aktive Billing-Account-ID
- `org_id` oder `folder_id`: nur bei Bedarf setzen, niemals beide gleichzeitig
- `state_bucket_name`: neuer weltweit eindeutiger Name fuer den Terraform-State-Bucket
- `bootstrap_user_member`: dein Benutzer im IAM-Format, z. B. `user:name@example.com`

4. In das Verzeichnis `IaC-Terraform/bootstrap` wechseln.

5. Terraform initialisieren, prüfen und ausführen:

   ```powershell
   terraform init
   terraform plan
   terraform apply
   ```

6. Die Outputs notieren. Typischerweise sind besonders wichtig:

- `backend_prefix`
- `project_id`
- `project_number`
- `state_bucket_name`
- `terraform_service_account_email`

Beispiel:

```text
backend_prefix                   = "static-website"
project_id                       = "project-dlbsepcp01-d-test-4"
project_number                   = "51957549123"
state_bucket_name                = "dev-terraform-state-bucket-test4-dlbsepcp01"
terraform_service_account_email  = "terraform-deployer@project-dlbsepcp01-d-test-4.iam.gserviceaccount.com"
```

## 2. Dev-Environment erstellen

1. Die Werte aus dem Bootstrap in `IaC-Terraform/enviroments/dev/terraform.tfvars`
   Übernehmen (.example als Grundlage):

   ```hcl
   project_id                      = "<PROJECT_ID_AUS_BOOTSTRAP>"
   bucket_name                     = "<NEUER_WELTWEIT_EINDEUTIGER_WEBSITE_BUCKET>"
   terraform_service_account_email = "<E-MAIL_DES_SERVICE_ACCOUNTS>"
   ```

Optional:

- `name_prefix` anpassen
- `bucket_location` aendern

Hinweis: `bucket_name` ist hier der Website-Bucket und nicht der State-Bucket.

2. In das Verzeichnis `IaC-Terraform/enviroments/dev` wechseln.

3. Das ADC-Quota-Projekt auf das neu angelegte GCP-Projekt setzen:

   ```powershell
   gcloud auth application-default set-quota-project <PROJECT_ID_AUS_BOOTSTRAP>
   ```

Hinweis: Bei neuen Projekten kann es nach dem Bootstrap und dem Setzen des
Quota-Projekts einige Minuten dauern, bis der Zugriff auf den GCS-Backend-Bucket
funktioniert. Falls `terraform init` zunächst mit
`UserProjectAccountProblem` fehlschlägt, kurz warten und den Befehl erneut
ausfuehren.

4. Terraform mit dem Backend-Bucket aus dem Bootstrap initialisieren:

   ```powershell
   terraform init -reconfigure -backend-config="bucket=<STATE_BUCKET_NAME_AUS_BOOTSTRAP>" -backend-config="prefix=<BACKEND_PREFIX_AUS_BOOTSTRAP>"
   ```

5. Terraform prüfen und ausführen:

   ```powershell
   terraform plan
   terraform apply
   ```

6. Nach dem Apply einige Minuten warten, bis die Website erreichbar ist. Im
   Terraform-Output wird eine IP-Adresse ausgegeben. Die Seite ist dann unter
   `http://<IP-ADRESSE>/index.html` erreichbar.

## Hinweise

- Für `gcloud auth application-default set-quota-project` sollte die
  Projekt-ID aus dem Bootstrap verwendet werden.
- Der Wert fuer `prefix` beim `terraform init` im Dev-Environment sollte aus dem
  Bootstrap-Output `backend_prefix` übernommen werden.
- Im Bootstrap heisst die Variable für den menschlichen Benutzer
  `bootstrap_user_member`. Dieser Name sollte in der Konfiguration verwendet
  werden.
