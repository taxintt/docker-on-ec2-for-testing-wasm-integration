# docker-on-ec2-for-testing-wasm-integration
## 0. create dev.tfvars

```bash
# create dev.tfvars
touch dev.tfvars

# create access key from AWS console
# see https://aws.amazon.com/jp/premiumsupport/knowledge-center/create-access-key/

# set and confirm keys
cat dev.tfvars
region         = "us-east-1"
aws_access_key = "xxxx"
aws_secret_key = "xxxx"

```

## 1. terraform init
```bash
❯ terraform init
```

## 2. terraform apply

```bash
❯ terraform apply -var-file=./dev.tfvars

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.instance will be created
  + resource "aws_instance" "instance" {

      ...
      + public_key_pem                = (known after apply)
      + rsa_bits                      = 4096
    }

Plan: 5 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

...
aws_instance.instance: Creation complete after 32s [id=i-09d69deee6a6404fb]

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.
```

## 3. installing WasmEdge
```bash
# wasmedge
curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | sudo bash -s -- -e all -p /usr/local

# containerd-shim-wasmedge
wget https://github.com/second-state/runwasi/releases/download/v0.3.3/containerd-shim-wasmedge-v1-v0.3.3-linux-amd64.tar.gz
tar -zxvf containerd-shim-wasmedge-v1-v0.3.3-linux-amd64.tar.gz
sudo mv containerd-shim-wasmedge-v1 /usr/local/bin/
```

## 4. Building and installing dockerd
ref: https://github.com/chris-crone/wasm-day-na-22/tree/main/server#building-and-installing-dockerd

## 5. Run wasm container
```bash
docker context create wasm --docker "host=unix:///tmp/docker.sock"

docker context use wasm
```

```bash
docker run -dp 8080:8080 \
  --name=wasm-example \
  --runtime=io.containerd.wasmedge.v1 \
  --platform=wasi/wasm32 \
  michaelirwin244/wasm-example

curl localhost:8080
Hello world from Rust running with Wasm! Send POST data to /echo to have it echoed back to you
```

ref: https://docs.docker.com/desktop/wasm/#running-a-wasm-application-with-docker-compose