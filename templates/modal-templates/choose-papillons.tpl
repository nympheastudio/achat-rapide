
<style>
    .papillon-selection {
    display: flex;
    flex-wrap: wrap; /* Allow items to wrap to the next line */
    gap: 20px; /* Adjust the gap between items as needed */
}

.papillon-selection-item {
    flex: 1; /* Allow items to grow and take equal space */
    max-width: calc(33.33% - 20px); /* Set the maximum width for each item (adjust as needed) */
    box-sizing: border-box; /* Include padding and borders in the item's width */
    text-align: center; /* Center content horizontally */
}

/* Adjust styling as needed */
.papillon-selection-item img {
    max-width: 100%;
    height: auto;
    min-width: 50px;
}

.papillon-selection-item p {
    margin-top: 10px; /* Add some spacing between the image and the text */
}
    .selected-img {
        border: 2px solid rgb(58, 58, 58); /* You can customize the border style */
    }
    .product_name {
        font-size: 9px;
        

    }


</style>
<h3>Commande "{$product_name}" </h3>
<p>Merci de cliquer sur le papillon que vous souhaitez :</p>

<button id="validateSelectionBtn" onclick="validateSelection();" class="btn btn-primary">Valider la sélection</button>
<div class="papillon-selection choose-papillons-content">
    {foreach from=$papillons_list item=product}
    <div class="papillon-selection-item">
        <img src="https://{$product.image}" alt="{$product.name}" data-product-id="{$product.id_product}">
        <p class="product_name"><!--{$product.name}-->&nbsp;</p>
    </div>
    {/foreach}
</div>


<div data-bs-keyboard="false" data-bs-backdrop="static" class="modal fade" id="chooseMaquetteModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        
        <div class="modal-content">
            <div class="modal-body"> </div>
            <button id="closeBtnChooseMaquetteModal" type="button" class="btn btn-primary" >Retour</button>
        </div>
    </div>
</div>

<script>
    function validateSelection() {
        // Find the selected papillon item
        var selectedPapillon = $('.papillon-selection-item.selected');
        
        // Check if a papillon is selected
        if (selectedPapillon.length === 1) {
            // Get the product_id and data-product-id attributes
            var product_id = {$smarty.get.product_id};
            var papillon_id = selectedPapillon.find('img').data('product-id');
            
            // Call openChooseMaquetteModal with the product_id and papillon_id
            openChooseMaquetteModal(product_id, papillon_id);
        } else {
            // Handle the case where no papillon is selected
            alert('Merci de sélectionner un modèle de papillon avant de valider');
        }
    }
    
    // Add click event handler to papillon selection items
  //  $('.papillon-selection-item').click(function() {
    $(document).on('click', '.papillon-selection-item', function() {
        // Deselect all items
        $('.papillon-selection-item.selected').removeClass('selected');
        $('.papillon-selection-item img.selected-img').removeClass('selected-img');
        
        // Select the clicked item
        $(this).addClass('selected');
        $(this).find('img').addClass('selected-img');
    });
</script>
<script>
    
   
    $(document).on('click', '#closeBtnChooseMaquetteModal', function() {
        $('#chooseMaquetteModal').modal('hide');
        openChoosePapillonsModal({$smarty.get.product_id});
    });
    
    
    function openChooseMaquetteModal(product_id, papillon_id) {
       
        $.ajax({
            url: 'index.php?step=choose-maquette&product_id=' + product_id + '&papillon_id=' + papillon_id, // Update the path to your 'choose-maquette.tpl' file
            success: function(data) {
                $('#chooseMaquetteModal .modal-body').html(data);
            }
        });
        
        $('.papillon-selection').hide();
        $('#chooseMaquetteModal').modal('show');
        
    }
</script>
