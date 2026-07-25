<?php
/**
 * Title: Home Board
 * Slug: post165/home-board
 * Categories: post165
 * Description: Compact strap plus the two-column answer board.
 *
 * @package post165
 */

$post165_charter = absint( post165_fact( 'charter_year', 0 ) );
?>
<!-- wp:group {"className":"post165-strap","layout":{"type":"default"}} -->
<div class="wp-block-group post165-strap">
	<!-- wp:html -->
	<div>
		<p class="post165-strap__title"><?php esc_html_e( 'Still here. Still serving.', 'post165' ); ?></p>
		<p class="post165-strap__lede"><?php esc_html_e( 'Veterans serving Two Rivers — ceremonies, community events, and each other.', 'post165' ); ?></p>
	</div>
	<?php if ( $post165_charter ) : ?>
	<div class="post165-strap__since">
		<b><?php echo esc_html( (string) $post165_charter ); ?></b>
		<span><?php esc_html_e( 'Chartered', 'post165' ); ?></span>
	</div>
	<?php endif; ?>
	<!-- /wp:html -->
</div>
<!-- /wp:group -->

<!-- wp:group {"className":"post165-board","layout":{"type":"default"}} -->
<div class="wp-block-group post165-board">
	<!-- wp:group {"className":"post165-board__main","layout":{"type":"default"}} -->
	<div class="wp-block-group post165-board__main">
		<!-- wp:post165/upcoming /-->
		<!-- wp:post165/year-strip /-->
	</div>
	<!-- /wp:group -->

	<!-- wp:group {"className":"post165-board__side","layout":{"type":"default"}} -->
	<div class="wp-block-group post165-board__side">
		<!-- wp:post165/join-panel /-->
	</div>
	<!-- /wp:group -->
</div>
<!-- /wp:group -->
