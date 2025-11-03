*** Settings ***
Documentation    Verifica flujos principales en Checkout.

Resource    ../../resources/keywords/browser_keywords.resource
Resource    ../../resources/keywords/general_keywords.resource
Resource    ../../resources/keywords/checkout_keywords.resource


Resource    ../../resources/variables/environment.resource
Resource    ../../resources/variables/checkout_urls.resource

Resource    ../../resources/locators/home_locators.resource
Resource    ../../resources/locators/checkout_locators.resource


Test Teardown   Close Browser

*** Test Cases ***
Test Checkout Small Ticket New User
    [Tags]    CSC-8202    smoke    Login  checkout    
    Open Browser To Checkout    small 
    Login Checkout  new_user
    Create New Adress In Checkout   new_user   San Salvador    San Salvador Centro    San Salvador
    Select Payment Method   credisiman

Test Checkout Small Ticket Mk New User
    [Tags]    CSC-8203    smoke    Login  checkout
    Open Browser To Checkout    small_mk
    Login Checkout  new_user
    Create New Adress In Checkout   new_user   Santa Ana    Santa Ana Centro    Santa Ana
    Select Payment Method   credisiman

Test Checkout Big Ticket New User
    [Tags]    XRAY-LOGIN-003    smoke    Login  checkout  
    Open Browser To Checkout    big 
    Login Checkout  new_user
    Create New Adress In Checkout   new_user   San Salvador    San Salvador Centro    San Salvador
    Select Payment Method   credisiman
    #Verify Order Confirmation

Test Checkout Split New User
    [Tags]    XRAY-LOGIN-004    smoke    Login  checkout
    Open Browser To Checkout    split_siman 
    Login Checkout  new_user
    Create New Adress In Checkout   new_user   San Salvador    San Salvador Centro    San Salvador
    Select Payment Method   credisiman
    #Verify Order Confirmation

Test Checkout Split Combinado New User
    [Tags]    XRAY-LOGIN-005    smoke    Login  checkout
    Open Browser To Checkout    split_siman_mk 
    Login Checkout  new_user
    Create New Adress In Checkout   new_user   San Salvador    San Salvador Centro    San Salvador
    Select Payment Method   credisiman
    #Verify Order Confirmation

