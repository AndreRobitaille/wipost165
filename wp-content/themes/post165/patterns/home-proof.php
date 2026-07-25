<?php
/**
 * Title: Home Proof Band
 * Slug: post165/home-proof
 * Categories: post165
 * Description: Photographs of the post at work. Renders nothing until images are set.
 *
 * @package post165
 */

/*
 * Photographs must be supplied by the post — see spec §4.7 and §9.
 * Until then this pattern renders nothing rather than showing placeholder
 * imagery. To enable: attach images via the Site Editor, or replace the
 * figures below with real wp:image blocks and factual captions.
 */
?>
<!-- wp:group {"className":"post165-proof","layout":{"type":"constrained"}} -->
<div class="wp-block-group post165-proof">
	<!-- wp:paragraph {"className":"post165-eyebrow"} -->
	<p class="post165-eyebrow"><?php esc_html_e( 'The work', 'post165' ); ?></p>
	<!-- /wp:paragraph -->
	<!-- wp:paragraph -->
	<p><?php esc_html_e( 'Photographs of the post at work go here — honor guard, brat fry, flag placement — each with a plain caption naming what it is and when it happened.', 'post165' ); ?></p>
	<!-- /wp:paragraph -->
</div>
<!-- /wp:group -->
