#!/usr/bin/env bash
ssh -i $(terraform output private_key_path) root@$(terraform output manager_public_ip)
