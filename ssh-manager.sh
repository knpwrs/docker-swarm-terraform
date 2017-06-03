#!/usr/bin/env bash
ssh root@$(terraform output manager_public_ip)
