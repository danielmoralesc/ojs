<?php

/**
 * @file plugins/themes/default/DefaultChildThemePlugin.inc.php
 *
 * Copyright (c) 2014-2016 Simon Fraser University Library
 * Copyright (c) 2003-2016 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class DefaultChildThemePlugin
 * @ingroup plugins_themes_default
 *
 * @brief Default theme
 */
import('lib.pkp.classes.plugins.ThemePlugin');

class ClassicChildThemePlugin extends ThemePlugin {
	/**
	 * Initialize the theme's styles, scripts and hooks. This is only run for
	 * the currently active theme.
	 *
	 * @return null
	 */
	public function init() {
		$this->setParent('classicthemeplugin');
		// $this->modifyStyle('stylesheet', array('addLess' => array('styles/remove-borders.less')));
		

		$additionalLessVariables = [];
		if ($this->getOption('primaryColor') !== '#ffd120') {
			$additionalLessVariables[] = '@primary-colour:' . $this->getOption('primaryColor') . ';';
		}
		
		// Importing Bootstrap's and tag-it CSS
		// $this->addStyle('app_css', 'resources/app.min.css');
		
		$this->addStyle('stylesheet', 'less/import.less');
		$this->modifyStyle('stylesheet', array('addLessVariables' => join($additionalLessVariables)));
	
		

		// Load custom js
		$this->addScript('custom_js', 'resources/custom.js');
	
	
	}

	/**
	 * Get the display name of this plugin
	 * @return string
	 */
	function getDisplayName() {
		return __('plugins.themes.classic-child.name');
	}

	/**
	 * Get the description of this plugin
	 * @return string
	 */
	function getDescription() {
		return __('plugins.themes.classic-child.description');
	}
}

?>
