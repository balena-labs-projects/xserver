#!/bin/bash

echo "balenaBlocks x11 version: $(cat VERSION)"

exec startx -- -listen tcp
