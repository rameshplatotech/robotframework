*** Settings ***
Resource    ../../resources/variables/variables.robot
Resource    ../../resources/keywords/ui_keywords.robot
Library     SeleniumLibrary

*** Test Cases ***
Valid User Can Login
    Open Browser To Login Page
    Login With Credentials    ${USERNAME}    ${PASSWORD}
    Page Should Contain Element    id=logoutBtn
    Close Browser
