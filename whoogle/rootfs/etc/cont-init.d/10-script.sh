#!/bin/bash

sed -i "s|path.startswith(self.value)|path.startswith(f'/{self.value}')|g" /whoogle/app/models/endpoint.py 
#sed -i "s|/{self.value}|aze{self.value}|g" /whoogle/app/models/endpoint.py
