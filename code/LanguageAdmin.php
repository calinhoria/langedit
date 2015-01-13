<?php
class LanguageAdmin extends LeftAndMain {
    private static $menu_title = "Translations";
    static $modules = null;
    
        static function set_allowed_modules($modules) {
        self::$modules = $modules;
    }

    private static $url_segment = "editlang";

    // private static $menu_priority = 100;

    private static $url_priority = 30;

    private static $menu_icon = "langedit/images/icon.png";

    public function init() {
        parent::init();

        //  die($_SERVER["DOCUMENT_ROOT"]);

        //Requirements::css("langedit/css/style.css");
        //Requirements::javascript("dashboard/javascript/jquery.flip.js");

    }

    public function getFiles() {

        $files = LanguageAdmin::$modules;
        $valid_dirs = array();
        $yaml_files = new ArrayList();

        foreach ($files as $file) {

            if (is_dir($_SERVER["DOCUMENT_ROOT"] . "/" . $file)) {

                if ((file_exists($_SERVER["DOCUMENT_ROOT"] . "/" . $file . "/_config.php") || $file == "themes")) {
                    $valid_dirs[] = $file;
                    $temp = "";
                    if ($file == "themes") {
                        $theme = SiteConfig::current_site_config() -> Theme;
                        if ($theme == "") {
                            $theme = SSViewer::current_theme();
                        }
                        $temp = glob($_SERVER["DOCUMENT_ROOT"] . "/themes/$theme/lang/*.yml");
                        //die(print_r($temp));
                    }
                    else {
                        $temp = glob($_SERVER["DOCUMENT_ROOT"] . "/" . $file . '/lang/*.yml');
                    }
                    if (is_array($temp)) {
                        foreach ($temp as $key => $value) {
                            $info = pathinfo($value);
                            $lang = new ViewableData();
                            $lang -> __set("Locale", $info["filename"]);
                            $lang -> __set("Path", $value);
                            $lang -> __set("Module", $file);
                            $locales = "";
                            if (SiteTree::has_extension("Translatable")) {
                                $locales = Translatable::get_allowed_locales();
                            }
                            else {
                                $locales = array("it_IT");
                            }
                            if (in_array($info["filename"], $locales)) {
                                $yaml_files -> push($lang);
                            }

                        }
                    }
                }
            }
        }

        return $yaml_files;
    }

    public function index($request) {

        // try{
        // $c = new TextCollector("it_IT");
        // $c -> run(LanguageAdmin::$exclude_modules, true);
        // }
        // catch(ErrorException $e){
        // die(print_r($e));
        // }
        //
        //

        return $this -> translate($request);
    }

    static $allowed_actions = array('translate', );
    public function getYaml($file) {
        $yml_data = new ArrayList();

        $yml_file = sfYaml::load($file);
        $item = new ViewableData();
        foreach ($yml_file as $locale => $fields) {
            $item -> __set("Locale", $locale);
            $item -> __set("Path", $file);
            $contexts = new ArrayList();
            foreach ($fields as $key => $properties) {
                $prop = new ArrayList();
                foreach ($properties as $klabel => $value) {
                    $vlabel = new ArrayData( array(
                        "Label" => $klabel,
                        "LabelValue" => $value
                    ));
                    $prop -> push($vlabel);
                }
                $key1 = str_replace(".", "_", $key);
                $vcontext = new ArrayData( array(
                    "ContextTitle" => $key,
                    "ContextID" => $key1,
                    "Labels" => $prop
                ));
                $contexts -> push($vcontext);
            }
            $item -> __set("Context", $contexts);
            $yml_data -> push($item);
        }

        return $yml_data;
    }

    public function url($vars) {
        return sprintf("%s://%s%s", isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] != 'off' ? 'https' : 'http', $_SERVER['HTTP_HOST'], $vars);
    }

    public function translate(SS_HTTPRequest $request) {
        $locales = "";
        if (SiteTree::has_extension("Translatable")) {
            $locales = Translatable::get_allowed_locales();
        }
        else {
            $locales = array("it_IT");
        }

        $locales_list = new ArrayList();
        foreach ($locales as $key => $value) {
            $obj = new ViewableData();

            $obj -> __set("Locale", $value);
            $obj -> __set("LocaleName", i18n::get_locale_name($value));
            $obj -> __set("Lang", i18n::get_lang_from_locale($value));
            $locales_list -> push($obj);
        }
        

        if ($request -> isAjax()) {

            if (isset($_POST["collect"])) {
                foreach ($locales as $value) {
                    $c = new TextCollector($value);
                    $c -> run(LanguageAdmin::$modules, true);

                }
                die(_t("SUCCESSFULL_COLLECT", "The text was collected."));
            }
            if (isset($_POST["save"])) {
                $lang_array[$_POST["locale"]] = $_POST[$_POST["locale"]];
                $file = $_POST["file"];
                $yml_file = sfYaml::dump($lang_array);
                if ($fh = fopen($file, "w")) {
                    fwrite($fh, $yml_file);
                    fclose($fh);
                   file_get_contents("http://$_SERVER[HTTP_HOST]?flush");
                }
                else {
                    throw new LogicException("Cannot write language file! Please check permissions of $langFile");
                }
                die();
            }
            $files = $this -> getFiles();
            if (isset($_POST["loadfiles"])) {
                //  die($this->getYaml($_POST["loadfiles"]));

                $this -> customise(array(
                    "Translations" => $this -> getYaml($_POST["loadfiles"]),
                    "Modules" => $files,
                    "Locales" => $locales_list,
                ));
                $content = $this -> renderWith('LanguageAdmin_Content');
                return $content;
            }
            else {
                $this -> customise(array(
                    "Modules" => $files,
                    "Translations" => $this -> getYaml($files -> filter(array('Locale' => $locales_list -> first() -> Locale)) -> first() -> Path),
                    "Locales" => $locales_list,
                    "CurrentLocale" => $locales_list -> first() -> LocaleName
                ));
                $content = $this -> renderWith('LanguageAdmin_Content');
                return $content;
            }

        }
        else {

            $files = $this -> getFiles();

            $this -> customise(array(
                "Modules" => $files,
                "Translations" => $this -> getYaml($files -> filter(array('Locale' => $locales_list -> first() -> Locale)) -> first() -> Path),
                "Locales" => $locales_list,
                "CurrentLocale" => $locales_list -> first() -> LocaleName
            ));

            $content = $this -> renderWith($this -> getViewer('translate'));
            return $content;

        }

    }

}
