# README

```

Note: The `r53_zone_id` points to **.ldn.devopsplayground.com**, so your domain name for the instance will be `<animal>.ldn.devopsplayground.com`..  

```bash
cd infrastructure
terraform init
terraform get
AWS_PROFILE=training terraform plan -var instances_to_deploy=1
AWS_PROFILE=training terraform apply -var instances_to_deploy=1
```

then you can browse/SSH `<animal>.ldn.devopsplayground.com`

```bash
user: centos  
pass: DevopsPlayground19
```