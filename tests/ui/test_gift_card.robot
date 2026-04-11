*** Settings ***
Resource    ../../resources/variables/variables.robot
Resource    ../../resources/keywords/ui_keywords.robot
Library     SeleniumLibrary
Test Teardown    Close Browser Session

*** Test Cases ***
User Can Open Virtual Gift Card And Fill Details
    Open Demo Web Shop Home
    Open Virtual Gift Card Product Page
    Product Name Should Be    $25 Virtual Gift Card
    Fill Virtual Gift Card Details    John Smith    john123@gmail.com    Ramesh Rao    rao123@gmail.com    Happy Birthday!

