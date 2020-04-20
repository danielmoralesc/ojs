 {**
 * templates/frontend/objects/article_details.tpl
 *
 * Copyright (c) 2014-2019 Simon Fraser University
 * Copyright (c) 2003-2019 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief View of an Article which displays all details about the article.
 *
 * @uses $article Article This article
 * @uses $issue Issue The issue this article is assigned to
 * @uses $section Section The journal section this article is assigned to
 * @uses $primaryGalleys array List of article galleys that are not supplementary or dependent
 * @uses $supplementaryGalleys array List of article galleys that are supplementary
 * @uses $keywords array List of keywords assigned to this article
 * @uses $pubIdPlugins Array of pubId plugins which this article may be assigned
 * @uses $copyright string Copyright notice. Only assigned if statement should
 *   be included with published articles.
 * @uses $copyrightHolder string Name of copyright holder
 * @uses $copyrightYear string Year of copyright
 * @uses $licenseUrl string URL to license. Only assigned if license should be
 *   included with published articles.
 * @uses $ccLicenseBadge string An image and text with details about the license
 * @uses $boolAuthorInfo bool to check whether at least one author has additional info
 *}

<article class="obj_article_details">
	{* Issue introduction area above articles *}
	{if $issue->hasDescription() || $issue->getLocalizedCoverImageUrl()}
		<div class="issue_heading issue-browse-left-nav page-column page-column--left js-left-nav-col">
			<div class="flex_container description_cover">
				{* Article/Issue cover image *}
				{if $publication->getLocalizedData('coverImage') || $issue->getLocalizedCoverImage()}
					<div class="issue_cover_block">
						{if $publication->getLocalizedData('coverImage')}
							{assign var="coverImage" value=$publication->getLocalizedData('coverImage')}
							<img
								class="cover_image"
								src="{$publication->getLocalizedCoverImageUrl($article->getData('contextId'))|escape}"
								alt="{$coverImage.altText|escape|default:''}"
							>
						{else}
							<a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
								<img
									class="cover_image"
									src="{$issue->getLocalizedCoverImageUrl()|escape}"
									alt="{$issue->getLocalizedCoverImageAltText()|escape|default:''}"
								>
							</a>
						{/if}
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
					</div>
				{/if}

				<div id="scrollMenu" class="responsive_issue_nav">

					{* <button class="toggle-left-col__close btn-as-icon icon-general-close"></button>
					<div class="responsive-nav-title">Issue navigation</div> *}

					<!--desktop / tablet navigation -->
					{* <ul id="largeJumptoSection" class="artTypeJumpLinks list-issue-jumplinks">
						{foreach name=sections key=currSectionId from=$publishedArticles item=section}
							<li class="section-jump-link parent noSubcat">
								<a class="jumplink js-jumplink scrollTo" href="#section{$currSectionId}">{$section.title|escape}</a>
							</li>
						{/foreach}
					</ul> *}
				</div>
			</div>
		</div>
	{/if}

	{* Articles *}
	<div class="sections page-column page-column--center">

		<div class="issue-browse-top issue-browse-mobile-nav js-issue-browse-mobile-nav">
            <button class="toggle-left-col toggle-left-col__issue btn-as-link">Issue Navigation</button>
        </div>

		{* Title, authors and Links *}
		<div class="article_summary_body">

			<div class="summary_title_wrapper">
				<h1 class="article-full-title">
					{$publication->getLocalizedFullTitle()|escape}
				</h1>
			</div>

			{* authors list *}
			{if $publication->getData('authors')}
				<div class="authors_info">
					<ul class="entry_authors_list">
						{strip}
							{foreach from=$publication->getData('authors') item=author key=authorNumber}
								<li class="entry_author_block{if $authorNumber > 4} limit-for-mobiles{elseif $authorNumber === 4} fifth-author{/if}">
									{if $author->getOrcid()}
										<a class="orcid-image-url" href="{$author->getOrcid()}"><img src="{$baseUrl}/{$orcidImageUrl}"></a>
									{/if}
									<span class="name_wrapper">
										<a class="more_button" data-toggle="modal" data-target="#modalAuthorBio{$authorNumber}">
											{$author->getFullName()|escape}
										</a>
										{* author's biography *}
										<div class="modal fade" id="modalAuthorBio{$authorNumber}" tabindex="-1" role="dialog" aria-labelledby="modalAuthorBioTitle" aria-hidden="true">
											<div class="modal-dialog" role="document">
												<div class="modal-content">
													<div class="modal-header">
														<h5 class="modal-title" id="modalAuthorBioTitle">{translate key="submission.authorBiography"}</h5>
														<button type="button" class="close" data-dismiss="modal" aria-label="Close">
															<span aria-hidden="true">&times;</span>
														</button>
													</div>
														<div class="modal-body">
														{if $author->getLocalizedBiography()}
															<span class="additional-author-name">{$author->getFullName()|escape}</span>
															<br/>
															<span class="additional-author-affiliation">{$author->getLocalizedAffiliation()|escape}</span>
															<br/><br/>
															<span>{$author->getLocalizedBiography()|strip_unsafe_html}</span>
															{else if $author->getLocalizedAffiliation() }
															<span class="additional-author-name">{$author->getFullName()|escape}</span>
															<br/>
															<span class="additional-author-affiliation">{$author->getLocalizedAffiliation()|escape}</span>
														{/if}
														</div>
													<div class="modal-footer">
														<button type="button" class="btn btn-primary" data-dismiss="modal">{translate key="plugins.themes.classic.close"}</button>
													</div>
												</div>
											</div>
										</div>
									</span>
									{if $authorNumber+1 !== $publication->getData('authors')|@count}
										<span class="author-delimiter">, </span>
									{/if}
								</li>
							{/foreach}
							{if $publication->getData('authors')|@count > 4}
								<span class="collapse-authors" id="show-all-authors"><ion-icon name="add-circle"></ion-icon></span>
								<span class="collapse-authors hide" id="hide-authors"><ion-icon name="remove-circle"></ion-icon></ion-icon></span>
							{/if}
						{/strip}
					</ul>
				</div>
			{/if}

			{* Show volumen, number, year and page *}
			{if $issue->getShowVolume() || $issue->getShowNumber() || $issue->getShowYear() || $issue->hasDescription()}
				<div class="issue_summary_title">
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
						{* Page numbers for this article *}
						{if $article->getPages()}
							<span class="pages">{translate key="plugins.themes.classic-child.pages-abbr"} {$article->getPages()|escape}</span>
						{/if}
					{/strip}
				</div>
			{/if}

			{* DOI (requires plugin) *}
			{foreach from=$pubIdPlugins item=pubIdPlugin}
				{if $pubIdPlugin->getPubIdType() != 'doi'}
					{continue}
				{/if}
				{assign var=pubId value=$article->getStoredPubId($pubIdPlugin->getPubIdType())}
				{if $pubId}
					{assign var="doiUrl" value=$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
					<div class="doi">
						<span class="doi_label">
							{capture assign=translatedDOI}{translate key="plugins.pubIds.doi.readerDisplayName"}{/capture}
							{translate key="semicolon" label=$translatedDOI}
						</span>
						<span class="doi_value">
							<a href="{$doiUrl}">
								{* maching DOI's (with new and old format) *}
								{$doiUrl|escape}
							</a>
						</span>
					</div>
				{/if}
			{/foreach}

			{* Publication & update dates; previous versions *}
			{* {if $publication->getData('datePublished')}
				<p>
				{translate key="submissions.published"} *}
				{* If this is the original version *}
				{* {if $firstPublication->getID() === $publication->getId()}
					{$firstPublication->getData('datePublished')|date_format:$dateFormatShort} *}
				{* If this is an updated version *}
				{* {else}
					{translate key="submission.updatedOn" datePublished=$firstPublication->getData('datePublished')|date_format:$dateFormatShort dateUpdated=$publication->getData('datePublished')|date_format:$dateFormatShort}
				{/if}
				</p> *}

				{* {if count($article->getPublishedPublications()) > 1}
				<h3>{translate key="submission.versions"}</h3>
				<ul>
					{foreach from=array_reverse($article->getPublishedPublications()) item=iPublication}
					{capture assign="name"}{translate key="submission.versionIdentity" datePublished=$iPublication->getData('datePublished')|date_format:$dateFormatShort version=$iPublication->getData('version')}{/capture}
					<li>
						{if $iPublication->getId() === $publication->getId()}
						{$name}
						{elseif $iPublication->getId() === $currentPublication->getId()}
						<a href="{url page="article" op="view" path=$article->getBestId()}">{$name}</a>
						{else}
						<a href="{url page="article" op="view" path=$article->getBestId()|to_array:"version":$iPublication->getId()}">{$name}</a>
						{/if}
					</li>
					{/foreach}
				</ul>
				{/if}
			{/if} *}

			{* Published date *}
			{* {if $article->getDatePublished()}
				<div class="published_date">
					<span class="published_date_label">
						{translate key="submissions.published"}:
					</span>
					<span class="published_date_value">
						{$article->getDatePublished()|date_format:$dateFormatLong}
					</span>
				</div>
			{/if} *}

			{* Keywords *}
			{if !empty($keywords[$currentLocale])}
				<div class="item keywords">
					{strip}
					<div class="keywords_label">
						{translate key="article.subject"}:&nbsp;
					</div>
					<ul class="keywords_value">
						{foreach from=$keywords item=keywordArray}
							{foreach from=$keywordArray item=keyword key=k}
								<li class="keyword_item{if $k>4} more-than-five{/if}">
									<span>{$keyword|escape}</span>{if $k+1 < $keywordArray|@count}<span class="keyword-delimeter{if $k === 4} fifth-keyword-delimeter hide"{/if}">,</span>{/if}
								</li>
							{/foreach}
							{if $keywordArray|@count > 5}<span class="ellipsis" id="keywords-ellipsis">...</span>
								<a class="more_button" id="more_keywords">
									{translate key="plugins.themes.classic.more"}
								</a>
								<br/>
								<a class="more_button hide" id="less_keywords">
									{translate key="plugins.themes.classic.less"}
								</a>
							{/if}
						{/foreach}
					</ul>
					{/strip}
				</div>
			{/if}

			{* Count downloads article *}
			{if $primaryGalleys}
				<div class=show-number-downloads>
				{assign var="galleysTotalView" value=0}
				{foreach from=$primaryGalleys item=galley name=galleyList}
				{* {$galley->getGalleyLabel()}{$galley->getViews()} *}
				{assign var="galleysTotalView" value=$galleysTotalView+$galley->getViews()}
				{/foreach}
				<p>{translate key="plugins.themes.classic-child.downloads-count"} {$galleysTotalView}</p>
				</div>
			{/if}

			{* Article Galleys *}
			{if $primaryGalleys}
				<div class="item galleys">
					{foreach from=$primaryGalleys item=galley}
						{include file="frontend/objects/galley_link.tpl" parent=$article galley=$galley purchaseFee=$currentJournal->getSetting('purchaseArticleFee') purchaseCurrency=$currentJournal->getSetting('currency')}
					{/foreach}
				</div>
			{/if}
			{if $supplementaryGalleys}
				<div class="item galleys">
					{foreach from=$supplementaryGalleys item=galley}
						{include file="frontend/objects/galley_link.tpl" parent=$article galley=$galley isSupplementary="1"}
					{/foreach}
				</div>
			{/if}

			{call_hook name="Templates::Article::Details"}

		</div>

		<div class="article_abstract_block" id="articleAbstractBlock">

			{* Abstract *}
			{if $publication->getLocalizedData('abstract')}
				<div class="abstract">
					<h2>{translate key="article.abstract"}</h2>
					{$publication->getLocalizedData('abstract')|strip_unsafe_html}
				</div>
			{/if}

			{* Article Galleys only for mobile view *}
			{* <div class="for-mobile-view">
				{if $primaryGalleys}
					<div class="item galleys">
						{foreach from=$primaryGalleys item=galley}
							{include file="frontend/objects/galley_link.tpl" parent=$article galley=$galley purchaseFee=$currentJournal->getSetting('purchaseArticleFee') purchaseCurrency=$currentJournal->getSetting('currency')}
						{/foreach}
					</div>
				{/if}
				{if $supplementaryGalleys}
					<div class="item galleys">
						{foreach from=$supplementaryGalleys item=galley}
							{include file="frontend/objects/galley_link.tpl" parent=$article galley=$galley isSupplementary="1"}
						{/foreach}
					</div>
				{/if}
			</div> *}

			{* How to cite *}
			{if $citation}
				<div class="item citation">
					<div class="sub_item citation_display">
						<h3>
							{translate key="submission.howToCite"}
						</h3>
						<div class="citation_format_value">
							<div id="citationOutput" role="region" aria-live="polite">
								{$citation}
							</div>
							<div class="citation_formats dropdown">
								<a class="btn btn-primary" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true"
								        aria-expanded="false">
									{translate key="submission.howToCite.citationFormats"}
								</a>
								<div class="dropdown-menu" aria-labelledby="dropdownMenuButton" id="dropdown-cit">
									{foreach from=$citationStyles item="citationStyle"}
										<a
												class="dropdown-cite-link dropdown-item"
												aria-controls="citationOutput"
												href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgs}"
												data-load-citation
												data-json-href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgsJson}"
										>
											{$citationStyle.title|escape}
										</a>
									{/foreach}
									{if count($citationDownloads)}
										<div class="dropdown-divider"></div>
										<h4 class="download-cite">
											{translate key="submission.howToCite.downloadCitation"}
										</h4>
										{foreach from=$citationDownloads item="citationDownload"}
											<a class="dropdown-item"
											   href="{url page="citationstylelanguage" op="download" path=$citationDownload.id params=$citationArgs}">
												<span class="fa fa-download"></span>
												{$citationDownload.title|escape}
											</a>
										{/foreach}
									{/if}
								</div>
							</div>
						</div>
					</div>
				</div>
			{/if}

			{* Licensing info *}
			{if $copyright || $licenseUrl}
				<div class="item copyright">
					{if $licenseUrl}
						{if $ccLicenseBadge}
							{if $copyrightHolder}
								<p>{translate key="submission.copyrightStatement" copyrightHolder=$copyrightHolder|escape copyrightYear=$copyrightYear|escape}</p>
							{/if}
							{$ccLicenseBadge}
						{else}
							<a href="{$licenseUrl|escape}" class="copyright">
								{if $copyrightHolder}
									{translate key="submission.copyrightStatement" copyrightHolder=$copyrightHolder|escape copyrightYear=$copyrightYear|escape}
								{else}
									{translate key="submission.license"}
								{/if}
							</a>
						{/if}
					{/if}
					{* Copyright modal. Show only if license is absent *}
					{if $copyright && !$licenseUrl}
						<a class="more_button" data-toggle="modal" data-target="#copyrightModal">
							{translate key="about.copyrightNotice"}
						</a>
						<div class="modal fade" id="copyrightModal" tabindex="-1" role="dialog" aria-labelledby="copyrightModalTitle" aria-hidden="true">
							<div class="modal-dialog" role="document">
								<div class="modal-content">
									<div class="modal-header">
										<h5 class="modal-title" id="copyrightModalTitle">{translate key="about.copyrightNotice"}</h5>
										<button type="button" class="close" data-dismiss="modal" aria-label="Close">
											<span aria-hidden="true">&times;</span>
										</button>
									</div>
									<div class="modal-body">
										{$copyright|strip_unsafe_html}
									</div>
									<div class="modal-footer">
										<button type="button" class="btn btn-primary" data-dismiss="modal">{translate key="plugins.themes.classic.close"}</button>
									</div>
								</div>
							</div>
						</div>
					{/if}
				</div>
			{/if}

			{call_hook name="Templates::Article::Main"}

			{* References *}
			{if $parsedCitations || $publication->getData('citationsRaw')}
				<div class="item references">
					<h3 class="label">
						{translate key="submission.citations"}
					</h3>
					{if $parsedCitations}
						<ol class="references-list">
							{foreach from=$parsedCitations item=parsedCitation}
								<li>{$parsedCitation->getCitationWithLinks()|strip_unsafe_html} {call_hook name="Templates::Article::Details::Reference" citation=$parsedCitation}</li>
							{/foreach}
						</ol>
					{else}
						<div class="value">
							{$publication->getData('citationsRaw')|escape|nl2br}
						</div>
					{/if}
				</div>
			{/if}

		</div><!-- .article_abstract_block -->

		{* {foreach name=sections key=currSectionId from=$publishedArticles item=section}
			<div class="section" id="section{$currSectionId}">
				{if $section.articles}
					{if $section.title}
						<h3 class="section_title">
							{$section.title|escape|upper}
						</h3>
					{/if}
					<div class="section_content">
						{foreach from=$section.articles item=article}
							{include file="frontend/objects/article_summary.tpl"}
						{/foreach}
					</div>
				{/if}
			</div>
		{/foreach} *}

	</div><!-- .Article -->

</article>
