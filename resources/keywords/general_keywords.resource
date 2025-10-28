*** Settings ***
Library    SeleniumLibrary
Library    DateTime

*** Keywords ***
Click Element By Type
    [Arguments]    ${element_identifier}    ${element_type}=button
    [Documentation]    Click especializado por tipo de elemento

    Page Should Contain Element    ${element_identifier}
    
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
        Click Element    ${element_identifier}
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
    

Fill Element By Text
    [Arguments]    ${element_identifier}    ${text_element}=""
    [Documentation]    Llenado de campos de texto

    Page Should Contain Element    ${element_identifier}
    Wait Until Element Is Visible    ${element_identifier}    10s
    
    IF    '${text_element}' != ''
        Input Text    ${element_identifier}    ${text_element}
    ELSE       
        ${mesage}    Catenate    No se especificó un dato válido para:    ${element_identifier}
        Log To Console    ${mesage}
    END
    

Select List Item
    [Arguments]    ${locator}    ${label}    ${timeout}=10s
    [Documentation]    Selecciona un item de lista con validación y timeout
    ...                - Espera a que la lista esté visible
    ...                - Selecciona por label
    ...                - Verifica la selección
    
    # Esperar a que la lista esté disponible
    Wait Until Element Is Visible    ${locator}    ${timeout}
    
    # Seleccionar el item
    Select From List By Label    ${locator}    ${label}
    
    # Verificar que se seleccionó correctamente
    ${selected_label}    Get Selected List Label    ${locator}
    Should Be Equal    ${selected_label}    ${label}
    
    Log To Console    ✅ Seleccionado: '${label}' en ${locator}     

Create Random Email
    [Documentation]    Generador de email para usuario nuevo
    ...                Formato: timestamp+test+@yopmail.com
    ...                Ejemplo: 20241215123045_test@yopmail.com
    
    ${timestamp}    Get Current Date    result_format=%Y%m%d%H%M%S
    ${random_email}    Catenate    SEPARATOR=    ${timestamp}    _test    @yopmail.com
    RETURN    ${random_email}
