*** Settings ***
Resource    ../../resources/variables/variables.robot
Resource    ../../resources/keywords/api_keywords.robot
Library     RequestsLibrary

*** Test Cases ***
API Login Returns Token
    ${token}=    Login Via API    ${USERNAME}    ${PASSWORD}
    Should Not Be Empty    ${token}
