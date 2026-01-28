*** Settings ***
Documentation    Verifica flujos principales en Checkout.

Resource    ../../resources/keywords/browser_keywords.resource
Resource    ../../resources/keywords/general_keywords.resource
Resource    ../../resources/keywords/checkout_keywords.resource

Test Teardown   Close Browser

*** Test Cases ***
Test Checkout Small Ticket New User
    [Documentation]    Verifica flujo de checkout para pequeño ticket con nuevo usuario.
    #    FINALIZADO
    [Tags]    CSC-8202  delivery_siman
    Open Browser To Checkout    any    sv
    Login Checkout  new_user
    Create New Adress In Checkout   new_user   Santa Ana    Santa Ana Centro    Santa Ana
    Select Payment Method   transferencia_bancaria
    Finish Purchase   no_verify

Test Checkout Split Siman Guest User
    #    FINALIZADO
    [Tags]    CSC-8202  split_siman    SmallTicket    BigTicket    guest_user
    Open Browser To Checkout    split_siman    sv
    Login Checkout  guest_user
    Select Split Delivery  guest_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV LA GRAN VIA 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split Siman New User    
    #    FINALIZADO
    [Tags]    CSC-8202  split_siman_new_user
    Open Browser To Checkout    split_siman    sv
    Login Checkout  new_user
    #Create New Adress In Checkout   new_user   San Salvador    San Salvador Centro    San Salvador
    Select Split Delivery  new_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV LA GRAN VIA 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split Siman Recurrent User
    #FINALIZADO
    [Tags]    CSC-8202  split_siman_recurrent_user 
    Open Browser To Checkout    split_siman    sv 
    Login Checkout  recurrent_user
    Select Split Delivery  recurrent_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV LA GRAN VIA 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split MK Guest User
    #FINALIZADO
    [Tags]    CSC-8202  split_siman_mk 
    Open Browser To Checkout    split_siman_mk    sv 
    Login Checkout  guest_user
    Select Split Delivery  guest_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV LA GRAN VIA 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split MK New User
    #FINALIZADO
    [Tags]    CSC-8202  split_siman_mk_new_user 
    Open Browser To Checkout    split_siman_mk    sv 
    Login Checkout  new_user
    Select Split Delivery  new_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV LA GRAN VIA 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split MK Recurrent User
    #FINALIZADO
    [Tags]    CSC-8202  split_siman_mk_recurrent_user
    Open Browser To Checkout    split_siman_mk    sv 
    Login Checkout  recurrent_user
    Select Split Delivery  recurrent_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV LA GRAN VIA
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split ST BT MK Guest User
    #FINALIZADO
    [Tags]    CSC-8202  split_st_bt_mk 
    Open Browser To Checkout    split_st_bt_mk    sv 
    Login Checkout  guest_user
    Select Split Delivery  guest_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV LA GRAN VIA 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify    

Test Checkout Split ST BT MK New User
    #FINALIZADO
    [Tags]    CSC-8202  split_st_bt_mk_new_user 
    Open Browser To Checkout    split_st_bt_mk    sv 
    Login Checkout  new_user
    Select Split Delivery  new_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV LA GRAN VIA 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split ST BT MK Recurrent User
    #FINALIZADO 
    [Tags]    CSC-8202  split_st_bt_mk_recurrent_user
    Open Browser To Checkout    split_st_bt_mk    sv
    Login Checkout  recurrent_user
    Select Split Delivery  recurrent_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV LA GRAN VIA
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split ST Moto Guest User
    #FINALIZADO
    [Tags]    CSC-8202  split_st_moto 
    Open Browser To Checkout    split_st_moto    sv 
    Login Checkout  guest_user
    Select Split Delivery  guest_user   San Salvador    San Salvador Centro    San Salvador    Motocity 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split ST Moto New User
    #FINALIZADO
    [Tags]    CSC-8202  split_st_moto_new_user 
    Open Browser To Checkout    split_st_moto    sv
    Login Checkout  new_user
    Select Split Delivery  new_user   San Salvador    San Salvador Centro    San Salvador    Motocity
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split ST Moto Recurrent User
    #FINALIZADO
    [Tags]    CSC-8202  split_st_moto_recurrent_user
    Open Browser To Checkout    split_st_moto    sv
    Login Checkout  recurrent_user
    Select Split Delivery  recurrent_user   San Salvador    San Salvador Centro    San Salvador    Motocity
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split BT Moto Guest User
    #FINALIZADO
    [Tags]    CSC-8202  split_bt_moto 
    Open Browser To Checkout    split_bt_moto    sv 
    Login Checkout  guest_user
    Select Split Delivery  guest_user   San Salvador    San Salvador Centro    San Salvador    Motocity 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split BT Moto New User
    #FINALIZADO
    [Tags]    CSC-8202  split_bt_moto_new_user 
    Open Browser To Checkout    split_bt_moto    sv
    Login Checkout  new_user
    Select Split Delivery  new_user   San Salvador    San Salvador Centro    San Salvador    Motocity
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split BT Moto Recurrent User
    #FINALIZADO
    [Tags]    CSC-8202  split_bt_moto_recurrent_user
    Open Browser To Checkout    split_bt_moto    sv
    Login Checkout  recurrent_user
    Select Split Delivery  recurrent_user   San Salvador    San Salvador Centro    San Salvador    Motocity
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split ST BT Moto Guest User
    #FINALIZADO
    [Tags]    CSC-8202  split_st_bt_moto 
    Open Browser To Checkout    split_st_bt_moto    sv 
    Login Checkout  guest_user
    Select Split Delivery  guest_user   San Salvador    San Salvador Centro    San Salvador    Motocity 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split ST BT Moto New User
    #FINALIZADO
    [Tags]    CSC-8202  split_st_bt_moto_new_user
    Open Browser To Checkout    split_st_bt_moto    sv
    Login Checkout  new_user
    Select Split Delivery  new_user   San Salvador    San Salvador Centro    San Salvador    Motocity
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split ST BT Moto Recurrent User
    #FINALIZADO
    [Tags]    CSC-8202  split_st_bt_moto_recurrent_user
    Open Browser To Checkout    split_st_bt_moto    sv
    Login Checkout  recurrent_user
    Select Split Delivery  recurrent_user   San Salvador    San Salvador Centro    San Salvador    Motocity
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split MK Moto Guest User
    #FINALIZADO
    [Tags]    CSC-8202  split_mk_moto 
    Open Browser To Checkout    split_mk_moto    sv 
    Login Checkout  guest_user
    Select Split Delivery  guest_user   San Salvador    San Salvador Centro    San Salvador    Motocity 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split MK Moto New User
    #FINALIZADO
    [Tags]    CSC-8202  split_mk_moto_new_user
    Open Browser To Checkout    split_mk_moto    sv
    Login Checkout  new_user
    Select Split Delivery  new_user   San Salvador    San Salvador Centro    San Salvador    Motocity
    Select Payment Method   transferencia_bancaria
    Finish Purchase    no_verify

Test Checkout Split MK Moto Recurrent User
    #FINALIZADO
    [Tags]    CSC-8202  split_mk_moto_recurrent_user
    Open Browser To Checkout    split_mk_moto    sv
    Login Checkout  recurrent_user
    Select Split Delivery  recurrent_user   San Salvador    San Salvador Centro    San Salvador    Motocity
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split ST BT MK Moto Guest User
    #FINALIZADO
    [Tags]    CSC-8202  split_st_bt_mk_moto 
    Open Browser To Checkout    split_st_bt_mk_moto    sv 
    Login Checkout  guest_user
    Select Split Delivery  guest_user   San Salvador    San Salvador Centro    San Salvador    Motocity 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split ST BT MK Moto New User
    #FINALIZADO
    [Tags]    CSC-8202  split_st_bt_mk_moto_new_user
    Open Browser To Checkout    split_st_bt_mk_moto    sv
    Login Checkout  new_user
    Select Split Delivery  new_user   San Salvador    San Salvador Centro    San Salvador    Motocity
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split ST BT MK Moto Recurrent User
    #FINALIZADO
    [Tags]    CSC-8202  split_st_bt_mk_moto_recurrent_user
    Open Browser To Checkout    split_st_bt_mk_moto    sv
    Login Checkout  recurrent_user
    Select Split Delivery  recurrent_user   San Salvador    San Salvador Centro    San Salvador    Motocity
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify
