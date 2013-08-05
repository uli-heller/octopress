#!/bin/sh
VERSION=2.3.11

gem uninstall rails -v "${VERSION}"
gem uninstall actionmailer -v "${VERSION}"
gem uninstall actionpack -v "${VERSION}"
gem uninstall activerecord -v "${VERSION}"
gem uninstall activeresource -v "${VERSION}"
gem uninstall activesupport -v "${VERSION}"
gem uninstall rack -v 1.1.1
