*** Settings ***
Library    SeleniumLibrary

*** Keywords ***
Click Element By Type
    [Arguments]    ${element_identifier}    ${element_type}=button
    [Documentation]    Click especializado por tipo de elemento

    Page Should Contain Element    ${element_identifier}
    Log    ✅ Elemento encontrado por ID    console=true

    # Estrategias específicas por tipo
    IF    '${element_type}' == 'button'
        Click Button Safe    ${element_identifier}
    ELSE IF    '${element_type}' == 'link'
        Click Link Safe    ${element_identifier}
    ELSE IF    '${element_type}' == 'checkbox'
        Click Checkbox Safe    ${element_identifier}
    ELSE IF    '${element_type}' == 'radio'
        Click Radio Button Safe    ${element_identifier}
    ELSE
        Click Element Safe    ${element_identifier}
    END

Click Button Safe
    [Arguments]    ${link_identifier}
    Wait Until Element Is Visible    ${link_identifier}    10s
    Click Element    ${link_identifier}

Click Link Safe
    [Arguments]    ${link_identifier}
    Wait Until Element Is Visible    ${link_identifier}    10s
    Scroll Element Into View    ${link_identifier}
    Click Link    ${link_identifier}

Click Checkbox Safe  
    [Arguments]    ${checkbox_identifier}
    Wait Until Element Is Visible    ${checkbox_identifier}    10s
    Select Checkbox    ${checkbox_identifier}

Click Radio Button Safe
    [Arguments]    ${radio_identifier}
    Wait Until Element Is Visible    ${radio_identifier}    10s
    Click Element    ${radio_identifier}
    