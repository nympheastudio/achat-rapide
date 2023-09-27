<?php

// Include PrestaShop configuration and initialization
require_once('../config/config.inc.php');
require_once('../init.php');

// Include the BuyController class (assuming it's in the same directory)
require_once('controllers/BuyController.php');


// Instantiate the BuyController
$buyController = new BuyController();

// Determine the step you want to display (e.g., product selection, choose papillons, etc.)
$step = isset($_GET['step']) ? $_GET['step'] : 'product-selection';

switch ($step) {
    case 'product-selection':
        $buyController->displayProductSelection();
        break;
    case 'choose-papillons':
        $buyController->displayChoosePapillons();
        break;
    case 'choose-maquette':
        $buyController->displayChooseMaquette();
        break;
    //create-account
    case 'create-account':
        $buyController->displayCreateAccount();
        break;
    //payment
    case 'payment':
        $buyController->displayPaymentForm();
        break;

        case "quantity":
            $buyController->displayQuantity();
            break;

            case "success":
                $buyController->displaySuccess();
                break;

                case "error":
                    $buyController->displayError();
                    break;
    // Add cases for other steps as needed
    default:
        // Handle unknown or invalid steps
        echo 'Invalid step.';
}

// Optionally, you can add more logic here if needed
