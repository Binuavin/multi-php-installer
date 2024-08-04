#!/bin/bash

confirm_installation() {
    whiptail --yesno "Do you want to install additional PHP versions?" 10 60
    return $?
}