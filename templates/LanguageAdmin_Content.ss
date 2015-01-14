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
        <p id="Form_EditForm_error" style="display: none" class="message good"></p>
        <h2 id="current_locale">$CurrentLocale</h2>
        <div>
            <label class="notranslate">Choose a module</label>
            <select class="dropdown has-chzn chzn-done" id="file_select" >
                <% if Modules %>
                <% loop Modules %>
                <option class="$Locale $Module notranslate" url="$Path" value="$Path">$Module</option>
                <% end_loop  %>
                <% end_if %>
            </select>
            <label class="notranslate">Choose a locale</label>
            <select class="dropdown has-chzn chzn-done" id="locale_select" >
                <% if Locales %>
                <% loop Locales %>
                <option class="notranslate" <% if First %>selected<% end_if  %> lang="$Lang" value="$Locale">$LocaleName</option>
                <% end_loop  %>
                <% end_if %>
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
                <label class="left notranslate" for="$Up.ContextID$Label" >$Label</label>
                <div class="middleColumn">

                    <input type="text" name="$Up.Up.Locale[$Up.ContextTitle][$Label]" value="$LabelValue.XML" class="text translate" id="$Up.ContextID$Label"/>
                    <!-- <button class="translate_button" type="button">Translate</button> -->
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