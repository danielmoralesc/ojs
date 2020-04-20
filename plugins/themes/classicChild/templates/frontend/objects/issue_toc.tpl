{**
 * templates/frontend/objects/issue_toc.tpl
 *
 * Copyright (c) 2014-2018 Simon Fraser University
 * Copyright (c) 2003-2018 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief View of an Issue which displays a full table of contents.
 *
 * @uses $issue Issue The issue
 * @uses $issueTitle string Title of the issue. May be empty
 * @uses $issueSeries string Vol/No/Year string for the issue
 * @uses $issueGalleys array Galleys for the entire issue
 * @uses $hasAccess bool Can this user access galleys for this context?
 * @uses $publishedArticles array Lists of articles published in this issue
 *   sorted by section.
 * @uses $primaryGenreIds array List of file genre ids for primary file types
 *}

<div class="obj_issue_toc">

	{* Published date *}
	{* {if $issue->getDatePublished()}
		<div class="published">
			<span class="date_label">
				{translate key="submissions.published"}
			</span>
			<span class="date_format">
					{$issue->getDatePublished()|date_format:$dateFormatLong}
			</span>
		</div>
	{/if} *}

	{* Indicate if this is only a preview *}
	{if !$issue->getPublished()}
		{include file="frontend/components/notification.tpl" type="warning" messageKey="editor.issues.preview"}
	{/if}

	{* Issue introduction area above articles *}
	{if $issue->hasDescription() || $issue->getLocalizedCoverImageUrl()}
		<div class="issue_heading issue-browse-left-nav page-column page-column--left js-left-nav-col">
			{* Description *}
			<div class="flex_container description_cover">
				{* {if $issue->hasDescription()}
					<div class="description">
						<h2 class="description_label">{translate key="plugins.themes.classic.issueDescription"}</h2>
						{assign var=issueDescription value=$issue->getLocalizedDescription()|strip_unsafe_html}
						{if $issueDescription|strlen < 800}
							<div class="description_text">
								{$issueDescription}
							</div>
						{elseif $requestedPage|escape !== "issue"}
							<div class="description_text">
								{$issueDescription|substr:0:800|mb_convert_encoding:'UTF-8'|replace:'?':''}<span
										class="three_dots">...</span>
								<a class="more_button"
								   href="{url op="view" page="issue" path=$issue->getBestIssueId()}">
									{translate key="plugins.themes.classic.more"}
								</a>
							</div>
						{else}
							<div class="description_text">
								{$issueDescription}
							</div>
						{/if}
					</div>
				{/if} *}

				{* Issue cover image *}
				{assign var=issueCover value=$issue->getLocalizedCoverImageUrl()}
				{if $issueCover}
					<div class="issue_cover_block{if !$issue->hasDescription()} align-left{/if}">
						<a href="{$issueCover|escape}" target="_blank">
							<img class="cover_image"
							     src="{$issueCover|escape}"{if $issue->getLocalizedCoverImageAltText() != ''} alt="{$issue->getLocalizedCoverImageAltText()|escape}"{/if}>
						</a>
					</div>
				{/if}

				{if $issue->getShowVolume() || $issue->getShowNumber() || $issue->getShowYear() || $issue->hasDescription()}
					<div class="issue_info_text">
						{strip}
							{if $issue->getVolume() && $issue->getShowVolume()}
								<span class="current-issue-volume">{translate key="plugins.themes.classic.volume-abbr"} {$issue->getVolume()|escape}</span>
							{/if}
							{if $issue->getNumber() && $issue->getShowNumber()}
								<span class="current-issue-number">{translate key="plugins.themes.classic.number-abbr"} {$issue->getNumber()|escape}</span>
							{/if}
							{if $issue->getYear() && $issue->getShowYear()}
								<span class="current-issue-year">{$issue->getDatePublished()|date_format:"%B"} {$issue->getYear()|escape}</span>
							{/if}
						{/strip}
						{* Text link with Modal for COver Image *}
						{* {if $issueCover}
							<div class="link-cover link">
								<span class="link-cover link" onclick="openBanner()">{translate key="plugins.themes.classicChild.cover-image"}</span>
								<div class="modal fade" id="modalCover" tabindex="-1" role="dialog" style="display: none;" aria-hidden="true">
									<div class="modal-dialog" role="document">
										<div class="modal-content">
											<div class="modal-header">
												<h5 class="modal-title">Portada</h5>
											<button type="button" class="close" onclick="openBanner()" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button></div>
											<div class="modal-body">
												<img src="{$issueCover|escape}"{if $issue->getLocalizedCoverImageAltText() != ''} alt="{$issue->getLocalizedCoverImageAltText()|escape}"{/if}>
											</div>
											<div class="modal-footer"><button type="button" class="btn btn-primary" onclick="openBanner()" data-dismiss="modal">Cerrar</button></div>
										</div>
									</div>
								</div>
							</div>
						{/if} *}
					</div>
				{/if}

				<div id="scrollMenu" class="responsive_issue_nav">

					<button class="toggle-left-col__close btn-as-icon icon-general-close"></button>
					<div class="responsive-nav-title">Issue navigation</div>

					<!--desktop / tablet navigation -->
					<ul id="largeJumptoSection" class="artTypeJumpLinks list-issue-jumplinks">
						{foreach name=sections key=sectionId from=$publishedSubmissions item=section}
							<li class="section-jump-link parent noSubcat">
								<a class="jumplink js-jumplink scrollTo" href="#section{$sectionId}">{$section.title|escape}</a>
							</li>
						{/foreach}
					</ul>
				</div>
			</div>
		</div>
	{/if}

	{* Full-issue galleys *}
	{if $issueGalleys}
		<div class="galleys">
			<h2 class="sr-only">
				{translate key="issue.tableOfContents"}
			</h2>
			<ul class="galleys_links">
				{foreach from=$issueGalleys item=galley}
					<li>
						{include file="frontend/objects/galley_link.tpl" parent=$issue purchaseFee=$currentJournal->getSetting('purchaseIssueFee') purchaseCurrency=$currentJournal->getSetting('currency')}
					</li>
				{/foreach}
			</ul>
		</div>
	{/if}

	{* Articles *}
	<div class="sections page-column page-column--center">
		<h2 class="sr-only">
			{translate key="issue.tableOfContents"}
		</h2>

		<div class="issue-browse-top issue-browse-mobile-nav js-issue-browse-mobile-nav">
            <button class="toggle-left-col toggle-left-col__issue btn-as-link">Issue Navigation</button>
        </div>

		{if $issue->getShowVolume() || $issue->getShowNumber() || $issue->getShowYear() || $issue->hasDescription()}
			<h1 class="issue-identifier">
				{strip}
					{if $issue->getVolume() && $issue->getShowVolume()}
						<span class="current-issue-volume">{translate key="plugins.themes.classic.volume-abbr"} {$issue->getVolume()|escape}</span>
					{/if}
					{if $issue->getNumber() && $issue->getShowNumber()}
						<span class="current-issue-number">{translate key="plugins.themes.classic.number-abbr"} {$issue->getNumber()|escape}</span>
					{/if}
					{if $issue->getYear() && $issue->getShowYear()}
						<span class="current-issue-year">{$issue->getDatePublished()|date_format:"%B"} {$issue->getYear()|escape}</span>
					{/if}
				{/strip}
			</h1>
		{/if}

		{foreach name=sections key=sectionId from=$publishedSubmissions item=section}
		
			<div class="section" id="section{$sectionId}">
				{if $section.articles}
					{if $section.title}
						<h3 class="section_title">
							{$section.title|escape}
						</h3>
					{/if}
					<div class="section_content">
						{foreach from=$section.articles item=article}
							{include file="frontend/objects/article_summary.tpl"}
						{/foreach}
					</div>
				{/if}
			</div>
		{/foreach}

		<a class="read_more btn btn-secondary" href="{url router=$smarty.const.ROUTE_PAGE page="issue" op="archive"}">
			{translate key="journal.viewAllIssues"}
		</a>
	</div><!-- .sections -->
</div>
