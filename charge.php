<?php
//display errors
error_reporting(E_ERROR | E_PARSE);
ini_set("display_errors", 1);

require_once "../config/config.inc.php";
require_once "../init.php";

// Include the Stripe PHP library and set your secret key
require_once "lib/stripe-php-master/init.php";

\Stripe\Stripe::setApiKey(
    "sk_test_51Nt8aGK0crUjstBWs3IWN5IyUeqatMEIxYSHcMkdbG7MKK0NVp5pbX2xsoBnvDgYxc7QLHrhGlIxv4tqnjLWr7Bg00MqUUYNqf"
);

// Retrieve token and additional data from the POST request
$stripeToken = $_POST["stripe_token"];
$productID = $_POST["product_id"];
$papillonID = $_POST["papillon_id"];
$maquette_id = $_POST["maquette_id"];
$quantity = $_POST["quantity"];
$total = eurosToCents($_POST["total"]);//convert to int and * 100


//nom, prenom ...
$nom = $_POST["nom"];
$prenom = $_POST["prenom"];
$email = $_POST["email"];
$adresse = $_POST["adresse"];
$code_postal = $_POST["code_postal"];
$ville = $_POST["ville"];
$telephone = $_POST["telephone"];

//function createCustomer in prestashop
function createCustomer()
{
    global $_POST;
    // Create a new customer
    $customer = new Customer();
    $customer->firstname = $_POST["prenom"];
    $customer->lastname = $_POST["nom"];
    $customer->email = $_POST["email"];
    $customer->passwd = md5("123456789azerty"); // You should hash the password correctly
    $customer->is_guest = 0;
    $customer->active = 1;

    if ($customer->add()) {
        // Customer added successfully
        //  echo 'Customer created successfully';
    } else {
        // Error occurred while creating the customer
        echo "Error creating customer";
    }

    return $customer;
}

function createAddress($customer)
{
    global $_POST;

    // echo 'dfgh'.$customer->id;exit;

    // Create a new customer address
    $address = new Address();
    $address->id_customer = $customer->id; // Set the customer ID
    $address->id_country = 8; // Set the country ID for France
    $address->alias = "My Address"; // Set an alias for the address (optional)
    $address->company = "My Company"; // Set the company name (optional)
    $address->lastname = $_POST["nom"];
    $address->firstname = $_POST["prenom"];
    $address->address1 = $_POST["adresse"];
    $address->postcode = $_POST["code_postal"];
    $address->city = $_POST["ville"];
    $address->phone = $_POST["telephone"];
    $address->active = 1; // Set the address as active

    if ($address->add()) {
        // Address added successfully
        // echo 'Customer address created successfully';
    } else {
        // Error occurred while creating the address
        echo "Error creating customer address";
    }

    return $address;
}
function createCart($address, $customer)
{
    global $_POST;

    global $productID;
    global $papillonID;
    global $maquette_id;
    global $quantity;
    global $total;


//echo 'productId'.$productID;exit;
    // Create a new cart
    $cart = new Cart();
    $cart->id_customer = $customer->id; // Set the customer ID
    $cart->id_address_delivery = $address->id; // Set the delivery address ID
    $cart->id_address_invoice = $address->id; // Set the invoice address ID
    $cart->id_currency = 1;
    $cart->id_lang = 1;
    $cart->id_carrier = 1;
    $cart->recyclable = 0;
    $cart->gift = 0;
    $cart->id_shop = 1;
    
    if($cart->add()){
        // echo 'cart created successfully';
    }else{
         echo 'error creating cart';
    }
/*
    try {
        // Add the main product to the cart
        if ($cart->updateQty($quantity, $productID, null, '')) {
            echo 'Main product added to the cart successfully: ' . $quantity . ' ' . $productID;
        } else {
            throw new Exception('Error adding the main product to the cart');
        }
    
        // Add the papillon product to the cart
        if ($cart->updateQty($quantity, $papillonID, null, '')) {
            echo 'Papillon product added to the cart successfully: ' . $quantity . ' ' . $papillonID;
        } else {
            throw new Exception('Error adding the papillon product to the cart');
        }
    
        // Save the cart
        if ($cart->save()) {
            echo 'Cart saved successfully';
        } else {
            throw new Exception('Error saving the cart');
        }
    } catch (Exception $e) {
        echo 'An error occurred: ' . $e->getMessage();
    }
    */

    return $cart;
}
function eurosToCents($amount_in_euros) {
    // Multiply the amount by 100 to convert euros to cents
    $amount_in_cents = $amount_in_euros * 100;

    // Round to the nearest whole number to ensure no fractional cents
    $amount_in_cents = round($amount_in_cents);

    return $amount_in_cents;
}



function createOrder($address, $customer, $cart)
{
    global $_POST;
    global $quantity;
    global $productID;
    global $papillonID;
    global $total;

    $total = $total / 100;

    // Ensure that the address is set correctly
    if (!$address instanceof Address) {
        echo "Error: Address is not set correctly.";
        return;
    }

    //test cart
    //echo 'cart'.$cart->id;exit;

    // Create a new order
    $order = new Order();
    $order->id_customer = $customer->id; // Set the customer ID
    $order->id_address_delivery = $address->id; // Set the delivery address ID
    $order->id_address_invoice = $address->id; // Set the invoice address ID
    $order->id_currency = 1;
    $order->id_lang = 1;
    $order->id_cart = $cart->id;
    $order->id_carrier = 1;
    $order->payment = "Stripe";
    $order->module = "Stripe";
    $order->total_paid = $total;
    $order->total_paid_tax_incl = $total;
    $order->total_paid_tax_excl = $total;
    $order->total_paid_real = $total;
    $order->total_products = $total;
    $order->total_products_wt = $total;
    $order->conversion_rate = 1;
    $order->secure_key = md5(uniqid(rand(), true));
    $order->reference = "STRIPE-" . time();
    $order->date_add = date("Y-m-d H:i:s");
    $order->date_upd = date("Y-m-d H:i:s");

    if ($order->add()) {
        // Order added successfully
        
            $order_detail = new OrderDetail(null, $productID);
            $order_detail->id_order = $order->id;
            $order_detail->product_name = 'carte personnalisée'.$productID;
            $order_detail->product_quantity = $quantity;
            $order_detail->product_price= $total;

            $order_detail->id_warehouse = 1;
            $order_detail->id_shop = 1;
            $order_detail->id_customization = 0;

            
            // Add the order detail to the database
            if ($order_detail->add()) {
                // Order detail added successfully
            } else {
                // Error occurred while creating the order detail
                echo "Error creating order detail for product: " . $product['name'];
            }
            $order_detail = new OrderDetail(null, $papillonID);
            $order_detail->id_order = $order->id;
            $order_detail->product_name = 'papillon'. $papillonID;
            $order_detail->product_quantity = $quantity;
            //price
            $order_detail->product_price= 0;//$total;
            $order_detail->id_warehouse = 1;
            $order_detail->id_shop = 1;
            $order_detail->id_customization = 0;

            
            // Add the order detail to the database
            if ($order_detail->add()) {
                // Order detail added successfully
            } else {
                // Error occurred while creating the order detail
                echo "Error creating order detail for product: " . $product['name'];
            }
        
        // ... (continue with the rest of your order creation code)
    } else {
        // Error occurred while creating the order
        echo "Error creating order";
    }
}

try {
    // Create a Stripe charge
    $charge = \Stripe\Charge::create([
        "amount" => $total, // Amount in cents (adjust as needed)
        "currency" => "eur", // Currency code (adjust as needed)
        "description" => "Product Purchase", // Description of the purchase
        "source" => $stripeToken, // Token obtained from the client-side
    ]);

    $create_customer = createCustomer();
    // Create a new customer address
    $create_address = createAddress($create_customer);

    //create cart
    $create_cart = createCart($create_address, $create_customer);

    $create_order = createOrder(
        $create_address,
        $create_customer,
        $create_cart
    );

    echo "Payment successful";
} catch (\Stripe\Exception\CardException $e) {
    // Handle card errors
    echo "Card declined: " . $e->getMessage();
} catch (\Stripe\Exception\RateLimitException $e) {
    // Handle rate limit errors
    echo "Rate limit exceeded";
} catch (\Stripe\Exception\InvalidRequestException $e) {
    // Handle invalid request errors
    echo "Invalid request: " . $e->getMessage();
} catch (\Stripe\Exception\AuthenticationException $e) {
    // Handle authentication errors
    echo "Authentication failed: " . $e->getMessage();
} catch (\Stripe\Exception\ApiConnectionException $e) {
    // Handle API connection errors
    echo "Network error: " . $e->getMessage();
} catch (\Stripe\Exception\ApiErrorException $e) {
    // Handle generic Stripe errors
    echo "Error: " . $e->getMessage();
} catch (Exception $e) {
    // Handle generic errors
    echo "Error: " . $e->getMessage();
}
