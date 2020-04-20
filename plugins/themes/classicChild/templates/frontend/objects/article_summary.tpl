{**
 * templates/frontend/objects/article_summary.tpl
 *
 * Copyright (c) 2014-2018 Simon Fraser University
 * Copyright (c) 2003-2018 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief View of an Article summary which is shown within a list of articles.
 *
 * @uses $article Article The article
 * @uses $hasAccess bool Can this user access galleys for this context? The
 *       context may be an issue or an article
 * @uses $showDatePublished bool Show the date this article was published?
 * @uses $hideGalleys bool Hide the article galleys for this article?
 * @uses $primaryGenreIds array List of file genre ids for primary file types
 *}

{assign var=articlePath value=$article->getBestId()}

{if (!$section.hideAuthor && $article->getHideAuthor() == $smarty.const.AUTHOR_TOC_DEFAULT) || $article->getHideAuthor() == $smarty.const.AUTHOR_TOC_SHOW}
	{assign var="showAuthor" value=true}
{/if}

<div class="article_summary">
	<div class="article_summary_body">
		<div class="summary_title_wrapper">
			<a class="summary_title" {if $journal}href="{url journal=$journal->getPath() page="article" op="view" path=$articlePath}"{else}href="{url page="article" op="view" path=$articlePath}"{/if}>
				{$article->getLocalizedFullTitle()|escape}
			</a>
		</div>

		{if $showAuthor || $article->getPages() || ($article->getDatePublished() && $showDatePublished)}
		<div class="summary_meta">
			{if $showAuthor}
			<div class="authors">
				{$article->getAuthorString()|escape}
			</div>
			{/if}

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

			{if $showDatePublished && $article->getDatePublished()}
				<div class="published">
					{$article->getDatePublished()|date_format:$dateFormatShort}
				</div>
			{/if}

		</div>
		{/if}

		<div class="summary_links">
			{* Abstract *}
			{if $article->getLocalizedData('abstract')}
				<div class="btn_abstract" onclick="expandAbstract(this)">
					<span class="link">Abstract</span>
					<div class="abstract">
						{$article->getLocalizedData('abstract')|strip_unsafe_html}
					</div>
				</div>
			{/if}
			<a class="link" {if $journal}href="{url journal=$journal->getPath() page="article" op="view" path=$articlePath}"{else}href="{url page="article" op="view" path=$articlePath}"{/if}>
				{translate key="plugins.themes.classic-child.view-article"}
			</a>
			{* Link for direct download *}
			{if !$hideGalleys}
				{foreach from=$article->getGalleys() item=galley}
					{if $primaryGenreIds}
						{assign var="file" value=$galley->getFile()}
						{if !$galley->getRemoteUrl() && !($file && in_array($file->getGenreId(), $primaryGenreIds))}
							{continue}
						{/if}
					{/if}
					{assign var="hasArticleAccess" value=$hasAccess}
					{if $currentContext->getSetting('publishingMode') == $smarty.const.PUBLISHING_MODE_OPEN || $publication->getData('accessStatus') == $smarty.const.ARTICLE_ACCESS_OPEN}
						{assign var="hasArticleAccess" value=1}
					{/if}
					{include file="frontend/objects/galley_direct.tpl" parent=$article hasAccess=$hasArticleAccess purchaseFee=$currentJournal->getSetting('purchaseArticleFee') purchaseCurrency=$currentJournal->getSetting('currency')}
				{/foreach}
			{/if}
		</div>
	</div>

	{call_hook name="Templates::Issue::Issue::Article"}
</div>
