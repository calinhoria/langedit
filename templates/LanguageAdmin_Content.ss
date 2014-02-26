
<div id="langedit" class="cms-content center " data-layout-type="border" data-pjax-fragment="Content"  data-base-url="$Link">
    <div style="padding: 10px" class="cms-content-header north">
        <div class="cms-content-header-info">
            <h2 class="notranslate"> Translate site labels </h2>
            <br />
            <button id="save" data-icon="disk" class="ss-ui-action-constructive ss-ui-button ">
                Save
            </button>
            <button id="collect" class="ss-ui-button ui-button-text-icon-primary notranslate" data-icon="arrow-circle-double" role="button" aria-disabled="false">
                Collect translations
            </button>

        </div>
    </div>
    <div style="padding: 20px;margin-top: 90px;padding-top: 20px" id="content">
        <p id="Form_EditForm_error" style="display: none" class="message good">
        </p>
        <h2 id="current_locale">$CurrentLocale</h2>
        <div>
            <label class="notranslate">Choose a module</label>
            <select class="dropdown has-chzn chzn-done" id="file_select" >
                <% loop Modules %>
                <option class="$Locale $Module notranslate" url="$Path" value="$Path">$Module</option>
                <% end_loop  %>
            </select>
            <label class="notranslate">Choose a locale</label>
            <select class="dropdown has-chzn chzn-done" id="locale_select" >
                <% loop Locales %>

                <option class="notranslate" <% if First %>selected<% end_if  %> lang="$Lang" value="$Locale">$LocaleName</option>
                <% end_loop  %>
            </select>
        </div>
        <form id="lang_fields">
            <% if Translations  %>
            <input type="hidden" name="save" value="true" />
            <% loop Translations  %>
            <input type="hidden" name="locale" value="$Locale" />
            <input type="hidden" name="file" value="$Path" />
            <% loop Context  %>
            <h2 class="field notranslate">$ContextTitle</h2>
            <input type="hidden" name="$Up.Locale[$ContextTitle]"/>
            <% loop Labels  %>
            <div  class="field text">
                <label class="left notranslate" for="$Label" >$Label</label>
                <div class="middleColumn">

                    <input type="text" name="$Up.Up.Locale[$Up.ContextTitle][$Label]" value="$LabelValue.XML" class="text translate" id="$Up.ContextID$Label"/>  <button class="translate_button" type="button">Translate</button>
                </div>
            </div>
            <% end_loop  %>
            <br />
            <% end_loop  %>
            <% end_loop  %>
            <% else  %>
            <h3>Select a module or theme directory</h3>
            <% end_if  %>
        </form>
    </div>

</div>
<style>
    #content
    {
        overflow: auto !important;
        overflow-x: hidden !important;
        position: absolute;
        bottom: 0;
        top: 0;
        right: 0;
        left: 0;
    }

    #langedit, body
    {
        overflow: hidden;
    }
    #google_translate_element
    {
        position: absolute;
        z-index: 1000;
        right: 0;
        top: 0;

    }
    .hidden
    {
        display: none;
    }
</style>
<script>

    jQuery(document).ready(function($) {


$("body").on("click",".translate_button",function(e)
{

    var elementId = $(this).prev().attr("id");

  $.ajax({
        type : "GET",
        url : "http://api.mymemory.translated.net/get",
        dataType : 'json',
        cache: false,
        contentType: "application/x-www-form-urlencoded; charset=UTF-8",
        data : "mt=true&de=belut_calin@yahoo.com&q="+$("#"+elementId).val()+"&langpair=en|"+$("#locale_select option:selected").attr("lang"),
        success : function(iData){

            $("#"+elementId).val(iData["responseData"]["translatedText"]);

        },
        error:function (xhr, ajaxOptions, thrownError){ }
    });
});

        $("#file_select option").hide();
            $("#file_select option." + $("#locale_select").val()).show();

        $("#locale_select").change(function() {
            $("#file_select option").hide();
            $("#file_select option." + $("#locale_select").val()).show();
        });

        var selected = $("." + $("#locale_select").val() + "." + $("#file_select option:selected").text()).attr("url");
        var locale = $("#locale_select option:selected").text();
        // $.ajax({
            // type : "POST",data : {
                // loadfiles : selected,
            // }
        // }).done(function(msg) {
//
            // $("#current_locale").html(locale);
            // $("#lang_fields").html($(msg).find('#lang_fields').html());
        // });
        $("#file_select,#locale_select").change(function() {
            selected = $("." + $("#locale_select").val() + "." + $("#file_select option:selected").text()).attr("url");
            locale = $("#locale_select option:selected").text();
            $.ajax({
                type : "POST",
                url:"http://gist.netechlab.it/admin/editlang/translate",
                data : {
                    loadfiles : selected,
                }
            }).done(function(msg) {
                // alert(msg);
                $("#current_locale").html(locale);
                $("#lang_fields").html($(msg).find('#lang_fields').html());
            });
        });

        $("#collect").click(function() {
            $(this).addClass('loading');
            var button = $(this);
            button.addClass("loading");
            $.ajax({
                type : "POST",
                data : {
                    collect : true,
                }
            }).done(function(msg) {
                button.removeClass("loading");
                $(".message").html("The translations were successfully collected.");
                $(".message").fadeIn().delay(3000).fadeOut();

            });
        });

        $("#save").click(function() {
            var button = $(this);
            button.addClass("loading");
            $.ajax({
                type : "POST",
                data : $("#lang_fields").serialize()
            }).done(function(msg) {
                button.removeClass("loading");
                $(".message").html("The translation was successfully saved.");
                $(".message").fadeIn().delay(3000).fadeOut();

            });
        });
    });

</script>
