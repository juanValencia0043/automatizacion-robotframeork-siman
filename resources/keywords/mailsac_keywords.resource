*** Settings ***
Library    Collections
Library    String
Library    RequestsLibrary
Resource    ../../resources/variables/environment.resource



*** Keywords ***
Disable SSL Warnings
    [Documentation]    Desactiva los warnings de SSL de urllib3
    Evaluate    __import__('urllib3').disable_warnings(__import__('urllib3').exceptions.InsecureRequestWarning)

Obtener Codigo OTP Mailsac
    [Arguments]    ${email_address}    ${max_reintentos}=3    ${tiempo_espera}=60s
    [Documentation]    Obtiene el código OTP del correo en Mailsac
    ...    Reintentos automáticos si no encuentra el correo o código OTP válido
    ...    Argumentos:
    ...    - email_address: Dirección de correo de Mailsac
    ...    - max_reintentos: Número máximo de reintentos (default: 3)
    ...    - tiempo_espera: Tiempo a esperar entre intentos (default: 20s)
    
    ${intento}=    Set Variable    0
    
    WHILE    ${intento} < ${max_reintentos}
        TRY
            #    Esperar a que caiga el mail
            Sleep    ${tiempo_espera}
            #    Configurar headers
            ${headers}=    Create Dictionary    Mailsac-Key=${MAILSAC_API_KEY}    Mailsac-Host=${MAILSAC_HOST}
            Create Session    mailsac    ${MAILSAC_BASE_URL}    headers=${headers}    verify=False
            #    Obtener mensajes
            ${response}=    GET On Session    mailsac    /addresses/${email_address}/messages
            Status Should Be    200    ${response}
            
            #    Validar que hay mensajes
            Should Not Be Empty    ${response.json()}    msg=No se encontraron mensajes en ${email_address}
            
            #    Obtener ID del mensaje mas reciente
            ${LAST_MESSAGE}=    Set Variable    ${response.json()[0]}
            ${message_id}=    Set Variable    ${LAST_MESSAGE['_id']}
            #    Obtener contenido del mensaje
            ${body_res}=    Get On Session    mailsac    /text/${email_address}/${message_id}
            #    Extraer codigo OTP del contenido
            ${OTP}=    Get Lines Matching Regexp    ${body_res.text}    \\d{6}
            
            #    Validar que se encontró el código OTP
            Should Not Be Empty    ${OTP}    msg=No se encontró código OTP válido en el correo
            
            Log    Código OTP obtenido exitosamente en el intento ${intento + 1}
            RETURN    ${OTP}
        EXCEPT    *
            ${intento}=    Evaluate    ${intento} + 1
            Log    Intento ${intento} fallido. Reintentando...    level=WARN
            
            IF    ${intento} >= ${max_reintentos}
                Fail    No se pudo obtener el código OTP después de ${max_reintentos} intentos
            END
        END
    END

