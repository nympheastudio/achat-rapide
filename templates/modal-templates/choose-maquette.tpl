
<h1>Commande "{$product_name}" </h1>
    <p>Réalisation de la maquette de votre carte de voeux</p>
    <div class="maquette-selection">
        <div class="maquette-selection-item">
           <button class="btn btn-primary" onclick="openQuantityModal({$smarty.get.product_id},{$smarty.get.papillon_id},1 );">Je m'occupe de la maquette</button>
        </div>
        <div class="maquette-selection-item">
             <button class="btn btn-primary" onclick="openQuantityModal({$smarty.get.product_id},{$smarty.get.papillon_id},2);">Je vous laisse faire</button>
        </div>
    </div>
    <div data-bs-keyboard="false" data-bs-backdrop="static" class="modal  fade" id="quantityModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
        <!-- Modal content goes here -->
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-body">
                    <!-- Content will be displayed here -->
                </div>
                <button id="closeBtnChooseQuantityModal" type="button" class="btn btn-primary" >Retour</button>
            </div>
        </div>
    <script>

//$('#closeBtnChooseQuantityModal').click(function() {
    $(document).on('click', '#closeBtnChooseQuantityModal', function() {
        $('#chooseQuantityModal').modal('hide');
        openChooseMaquetteModal({$smarty.get.product_id},{$smarty.get.papillon_id});
    });


        function openQuantityModal(product_id, papillon_id,maquette_id) {
            
           // document.querySelector('#quantityModal .modal-body').innerHTML = '<p>Product ID: ' + product_id + '</p>';
            //document.querySelector('#quantityModal .modal-body').innerHTML += '<p>Papillon ID: ' + papillon_id + '</p>';
            // Load the content of 'choose-maquette.tpl' into the modal using AJAX
            $.ajax({
                url: 'index.php?step=quantity&product_id=' + product_id + '&papillon_id=' + papillon_id + '&maquette_id=' + maquette_id, // Update the path to your 'choose-maquette.tpl' file 
                success: function(data) {
                    $('#quantityModal .modal-body').html(data);
                }
            });
            $('.maquette-selection').hide();
            $('#quantityModal').modal('show');
        }
    </script>
