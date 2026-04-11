*** Settings ***
Library    SeleniumLibrary
Resource    ../variables/variables.robot

*** Keywords ***

Close Browser Session
    SeleniumLibrary.Close Browser

Open Demo Web Shop Home
    Open Browser    ${DEMO_WEBSHOP_URL}    ${BROWSER}
    Maximize Browser Window

Open Virtual Gift Card Product Page
    Scroll Element Into View    xpath=//a[normalize-space()='$25 Virtual Gift Card']
    Click Element    xpath=//a[normalize-space()='$25 Virtual Gift Card']/ancestor::div[contains(@class,'product-item')]//input[@value='Add to cart']
    Wait Until Page Contains Element    id=giftcard_2_RecipientName    timeout=10s

Fill Virtual Gift Card Details
    [Arguments]    ${recipient_name}    ${recipient_email}    ${your_name}    ${your_email}    ${message}
    Input Text    id=giftcard_2_RecipientName    ${recipient_name}
    Input Text    id=giftcard_2_RecipientEmail    ${recipient_email}
    Input Text    id=giftcard_2_SenderName    ${your_name}
    Input Text    id=giftcard_2_SenderEmail    ${your_email}
    Input Text    id=giftcard_2_Message    ${message}

Product Name Should Be
    [Arguments]    ${expected_name}
    Element Text Should Be    css=div.product-name h1    ${expected_name}

