<?php
	/**
	 * @package cms
	 * @subpackage tasks
	 */
	class GenerateTranslationTask extends BuildTask
	{
		private static $allowed_actions = array('*' => 'ADMIN');

		protected $title = 'Generate translation task';

		protected $description = 'Generate a duplicate translation for a Locale from default Locale';

		public function run($request)
		{
			$locale=Translatable::default_locale();
			$pages=SiteTree::get()->where("Locale='{$locale}'");
			foreach ($pages as $page) {
				$translated=$page->createTranslation("en_GB");
				$translated->doPublish();
				// $page->doUnpublish();
             // $page->delete();
			}




		}




	}
