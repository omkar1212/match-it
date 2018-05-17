<decktemplate>
    <div id="action-bar" class="row align-items-center">
        <div class="col form-inline">
            <i class="fa fa-repeat action-btn btn btn-info"  title="Arrange Randomly" onclick={ rotateRandomly }></i>

            <div class="input-group">
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" value="" id="resize-action" checked>
                    <label class="form-check-label" for="resize-action">
                        Maintain height-width ratio
                    </label>
                </div>
                <span class="fa-stack fa-lg action-btn btn btn-info" title="Resize Randomly" style="font-size: 1.2em;" onclick={resizeRandomly}>
                    <i class="fa fa-square-o fa-stack-2x" style="top: -0.5px;"></i>
                    <i class="fa fa-arrows-h fa-stack-1x" style="top: -0.5px;"></i>
                </span>
            </div>
            
            <i class="fa fa-random action-btn btn btn-info"  title="Arrange Randomly" onclick={ arrangeRandomly }></i>
            <i class="fa fa-copy action-btn btn btn-info"  title="Copy Pattern" onclick={ this.parent.arrangeRandomly }></i>
            <i class="fa fa-paste action-btn btn btn-info"  title="Paste Pattern" onclick={ this.parent.arrangeRandomly }></i>
            

            <label class="btn-bs-file">
                <i class="fa fa-folder-open-o action-btn btn btn-info"  title="Open Pattern file" onclick={ this.parent.arrangeRandomly }></i>
                <input type="file" class="filebutton" accept="application/vnd.nimn,*.nmn,*.nimn"  onchange= { readTemplateFile }/>
            </label>
            
            <div class="form-inline input-group">
                <input id="exportTemplateName" type="text" class="form-control" placeholder="Enter the template name " value={  exportTemplateName} style="width: 300px;">
                <i class="fa fa-save action-btn btn btn-info"  title="Save Pattern to external file" onclick={ exportTemplate }></i>
            </div>
        </div>
        <!--  <div class="col">
            <select id="templateselect" class="form-control" onchange={loadtemplate}>
                <option disabled="true">Select template</option>
                <option value="normal" selected>3-250x350-match-it</option>
                <option value="pocker" >Pocker Playing Card</option>
                <option value="domino" >Domino Card</option>
                <option value="square" >Square Card</option>
            </select>
        </div>  -->
        
            <!--  <button class="btn-icon"><i src="static/img/pattern.svg" title="Arrang with appropriate template" onclick={ arrangeWithTemplate }></button>  -->
        </div>
    </div>
    <!--  <div class="row warnmessage">
        <div class="col-12">This template might not be suitable for selected card size.</div>
    </div>  -->
    <script>
    
        selectCards(cb,...arg){
            var elArr = $(".cf-selected");

            if(elArr.length === 0){
                elArr = $(".cardframe");
            }
            elArr.each( function(i) {
                cb($(this).find(".symbol"), ...arg);
            })
        }

        arrangeRandomly(){
            this.selectCards(setRandomPos);
        }

        rotateRandomly(){
            this.selectCards(rotateSymbolsRandomly);
        }

        resizeRandomly(){
            var maintainRatio = $("#resize-action").prop("checked");
            this.selectCards(resizeSymbolsRandomly, maintainRatio, this.parent.frame.desiredSymbolSize);
        }

        /*loadtemplate(e){
            
            var templateName = e.target.value + ".nimn";
            $.ajax({
                url: "./templates/"+templateName,
                type: "GET",
                dataType: "json",
                contentType: "application/vnd.nimn; charset=utf-8",
                success: data => {
                    var templateData = JSON.parse(data);
                    //this.parent.templates[templateName] = templateData;
                    //var widthDifference = ( templateData.width * 100) / Math.abs(this.parent.frame.width - templateData.width)
                    //var heightDifference = ( templateData.height * 100) / Math.abs(this.parent.frame.height - templateData.width)
                    
                    //set margin as per height width difference

                    this.parent.applyTemplate(templateData);
                }
            });
        }*/
        this.exportTemplateName = `${this.parent.frame.symbolsPerCard}-${this.parent.frame.width}x${this.parent.frame.height}-match-it`;
        readTemplateFile(f){
            var input = f.srcElement;
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = e => {
                    this.parent.applyTemplate(JSON.parse(e.target.result));
                }
                reader.onloadend = e => {
                    this.update();
                    reader = null;
                }
                reader.readAsText(input.files[0]);
            }
        }
        
        exportTemplate(e){
            var deck = {
                frame : this.parent.frame,
                cards: {}
            };
            $(".cardframe").each(function(fi){
                var totalWeight =0;
                var symbols = {
                    "1" : [],
                    "2" : []
                };

                $(this).find(".symbol").each( function(si,symbol){
                    //var thumbnail = $(this).find("img")[0];
                    var height = $(symbol).height();
                    var width = $(symbol).width();
                    var weight = $(symbol).attr("weight");

                    symbols[weight].push({
                        top: $(this).position().top,
                        left: $(this).position().left,
                        height: height,
                        width: width,
                        transform: $(this).css("transform"),
                    });

                    totalWeight += Number.parseInt(weight);
                });
                if(!deck.cards[totalWeight]){
                    deck.cards[totalWeight] = [];
                }
                deck.cards[totalWeight].push(symbols);
            })
            //TODO: convert to nimn first
            //download(JSON.stringify(deck), `${deck.frame.symbolsPerCard}-${this.frame.width}x${this.frame.height}-match-it.json` ,"application/json");
            var data = JSON.stringify(deck);
            var fileName = this.root.querySelector('#exportTemplateName').value + ".nimn";

            download( data, fileName ,"application/vnd.nimn");
        }
    </script>
</decktemplate>