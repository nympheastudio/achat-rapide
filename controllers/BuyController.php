<?php

class BuyController
{
    public function init()
    {
        // Include PrestaShop configuration and initialization
        require_once('../config/config.inc.php');
        require_once('../init.php');
    }

    public function displayProductSelection()
    {
        // Initialize PrestaShop context
        $context = Context::getContext();

        // Assign any necessary template variables
        $context->smarty->assign('product_list', $this->getProductList());

        // Display the product selection template
        $context->smarty->display( 'templates/modal-templates/product-selection.tpl');
    }

    public function displayChoosePapillons()
    {
        // Initialize PrestaShop context
        $context = Context::getContext();

        //getPapillonsList
        $context->smarty->assign('papillons_list', $this->getPapillonsList());

        // Display the "choose-papillons.tpl" template
        $context->smarty->display( 'templates/modal-templates/choose-papillons.tpl');
    }

    public function displayChooseMaquette()
    {
        // Initialize PrestaShop context
        $context = Context::getContext();
        $product_id = Tools::getValue('product_id');
        $product_name = Product::getProductName($product_id);

        $context->smarty->assign('product_name', $product_name);
        // Display the "choose-maquette.tpl" template
        $context->smarty->display( 'templates/modal-templates/choose-maquette.tpl');
    }

    //step create account
    public function displayCreateAccount()
    {
        // Initialize PrestaShop context
        $context = Context::getContext();

        $product_id = Tools::getValue('product_id');
        $product_name = Product::getProductName($product_id);

        $context->smarty->assign('product_name', $product_name);

        // Display the "choose-maquette.tpl" template
        $context->smarty->display( 'templates/modal-templates/create-account.tpl');
    }

    //step payment
    public function displayPaymentForm()
    {

        
        // Initialize PrestaShop context
        $context = Context::getContext();


        $total = 0;

        /*get
        p id: 341

pap id: 6

Maquette ID: 1

Quantity: 16
*/
$product_id = Tools::getValue('product_id');
$papillon_id = Tools::getValue('papillon_id');
$maquette_id = Tools::getValue('maquette_id');
$quantity = Tools::getValue('quantity');

//get product price
$product = new Product($product_id, false, $context->language->id);
$product_price = $product->price;


$total = $product_price * $quantity;

//set tpl total var
$context->smarty->assign('total', $total);



        // Display the "choose-maquette.tpl" template
        $context->smarty->display( 'templates/modal-templates/payment.tpl');
    }

    //display quantity
    public function displayQuantity()
    {
        // Initialize PrestaShop context
        $context = Context::getContext();

        $product_id = Tools::getValue('product_id');
        $product_name = Product::getProductName($product_id);

        $context->smarty->assign('product_name', $product_name);

        // Display the "choose-maquette.tpl" template
        $context->smarty->display( 'templates/modal-templates/quantity.tpl');
    }

    //diplsay success
    public function displaySuccess()
    {
        // Initialize PrestaShop context
        $context = Context::getContext();

        // Display the "choose-maquette.tpl" template
        $context->smarty->display( 'templates/modal-templates/success.tpl');
    }

    //display error
    public function displayError()
    {
        // Initialize PrestaShop context
        $context = Context::getContext();

        // Display the "choose-maquette.tpl" template
        $context->smarty->display( 'templates/modal-templates/error.tpl');
    }

    // Add similar functions for other steps (e.g., displayChooseQuantity, displayCreateAccount, displayPaymentForm)

    private function getProductList()
    {
        // Initialize PrestaShop context
        $context = Context::getContext();
    
        // Define an array to store product data
        $productList = [];
    
        // Fetch product data for products 341, 342, and 343
        $productIds = [341, 342, 343];
    
        foreach ($productIds as $productId) {
            $product = new Product($productId, false, $context->language->id);
            
            // Add the product data to the list
            $productList[] = [
                'id_product' => $product->id,
                'name' => $product->name,
                'description' => $product->description,
                'price' => $product->price,
                // Add other product attributes as needed
            ];
        }
    
        return $productList;
    }

    //get papillons list (product from category 51)
    private function getPapillonsList()
    {
        // Initialize PrestaShop context
        $context = Context::getContext();

        $product_id = Tools::getValue('product_id');
        $product_name = Product::getProductName($product_id);

        $context->smarty->assign('product_name', $product_name);
    
        // Define an array to store product data
        $productList = [];
    
        // Fetch product data for products from category 51
        $productIds = Db::getInstance()->executeS('SELECT id_product FROM '._DB_PREFIX_.'category_product WHERE id_category = 51');

        foreach ($productIds as $productId) {
            $product = new Product($productId['id_product'], false, $context->language->id);

            $image = Image::getCover($product->id);
            $link = new Link; // because getImageLink is not static function
            $imagePath = $link->getImageLink($product->link_rewrite, $image['id_image'], 'home_default');
            
            // Add the product data to the list
            $productList[] = [
                'id_product' => $product->id,
                'name' => $product->name,
                'description' => $product->description,
                'price' => $product->price,
                'image' => $imagePath,
                // Add other product attributes as needed
            ];
        }
        return $productList;
    }
/*
$id_product = $id; // set your product ID here
			$image = Image::getCover($id_product);
			$product = new Product($id_product, false, Context::getContext()->language->id);
			$link = new Link; // because getImageLink is not static function
			$imagePath = $link->getImageLink($product->link_rewrite, $image['id_image'], 'home_default');
			
			
			
			if($type=='image'){
				echo '<img src="https://'.$imagePath.'" width="100px" height="100px" />
				';
			}else{
				echo  'https://'.$imagePath;
			}
            */
    
}
