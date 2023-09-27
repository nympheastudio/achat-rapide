

<div id="choose_qty">
    <h3>Commande "{$product_name}" </h3>
    <p>Merci de choisir la quantité de carte de voeux 2024 (carte +papillon)</p>
    <!-- 
    <p>Product ID: {$smarty.get.product_id}</p>
    <p>Papillon ID: {$smarty.get.papillon_id}</p>
    <p>Maquette ID: {$smarty.get.maquette_id}</p>
 -->
    <select name="quantity" id="quantity">

        <!-- option by default not selectable -->
        <option value="" disabled selected>Choisir une quantité</option>
        
        {for $i=1 to 100}
        <option value="{$i}">{$i}</option>
        {/for}
    </select>
</div>
    <div data-bs-keyboard="false" data-bs-backdrop="static" class="modal fade" id="createAccountModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
        <!-- Modal content goes here -->
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-body"></div>
                <button id="closeBtncreateAccountModal" type="button" class="btn btn-primary" >Retour</button>
            </div>
        </div>


    <script>




$(document).ready(function(){

    $('#closeBtncreateAccountModal').click(function() {
        
        $('#createAccountModal').modal('hide');
        openQuantityModal({$smarty.get.product_id},{$smarty.get.papillon_id}, {$smarty.get.maquette_id});
    });


    $(document).on('change', '#quantity', function() {
        let quantity = $(this).val();
        console.log('change qty to ' + quantity);
        openCreateAccountModal({$smarty.get.product_id},{$smarty.get.papillon_id},{$smarty.get.maquette_id}, quantity);
    });


    });
function openCreateAccountModal( product_id, papillon_id, maquette_id,quantity) {

     $.ajax({
        url: 'index.php?step=create-account&product_id=' + product_id + '&papillon_id=' + papillon_id + '&maquette_id=' + maquette_id + '&quantity=' + quantity, // Update the path to your 'choose-maquette.tpl' file
        success: function(data) {
            $('#createAccountModal .modal-body').html(data);
        }
    });
    $('#choose_qty').hide();
    $('#createAccountModal').modal('show');
}


    </script>