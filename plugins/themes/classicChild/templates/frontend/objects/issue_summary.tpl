{**
 * templates/frontend/objects/issue_summary.tpl
 *
 * Copyright (c) 2014-2018 Simon Fraser University
 * Copyright (c) 2003-2018 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief View of an Issue which displays a summary for use in lists
 *
 * @uses $issue Issue The issue
 *}

{if $issue->getShowTitle()}
{assign var=issueTitle value=$issue->getLocalizedTitle()}
{/if}
{assign var=issueSeries value=$issue->getIssueSeries()}
{assign var=issueCover value=$issue->getLocalizedCoverImageUrl()}

<div class="obj_issue_summary">

	{if $issueCover}
		<a class="cover" href="{url op="view" path=$issue->getBestIssueId()}">
			<img class="archive_issue_cover" src="{$issueCover|escape}"{if $issue->getLocalizedCoverImageAltText() != ''} alt="{$issue->getLocalizedCoverImageAltText()|escape}"{/if}>
		</a>
	{/if}

	{if $issue->getLocalizedTitle() && $issue->getShowTitle()}
		<a class="issue_title" href="{url op="view" path=$issue->getBestIssueId()}">
			{$issue->getLocalizedTitle()|escape}
		</a>
	{/if}

	{if $issue->getShowVolume() || $issue->getShowNumber() || $issue->getShowYear() || $issue->hasDescription()}
		<a class="issue_summary_title" href="{url op="view" path=$issue->getBestIssueId()}">
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
				{if $issue->hasDescription()}
					<div class="description">
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
				{/if}
			{/strip}
		</a>
	{/if}

	{* <div class="issue_summary_date">
		{$issue->getDatePublished()|date_format:$dateFormatLong}
	</div> *}
</div><!-- .obj_issue_summary -->
