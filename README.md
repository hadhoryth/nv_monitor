# Nvidia monitor app (OSX app for monitoring Nvidia GPU via SSH Connection)

## Description

The main purpose of this util is to monitor remote GPU's parameters: utilization and temperature. The update is done via SSH Connection. In order to get the app working edit ``` Definitios.swift ``` with valid ``` user_id ```, ``` host_address ``` and ``` password ```. Accessing with rsa key currently **not** available.

## Interface

The status is updated every **5** minutes, it's posible to change ``` update_rate ``` in the ``` Definitios.swift ``` file. 



