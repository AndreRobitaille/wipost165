<?php
/**
 * Settings → Post 165. Facts that go stale must be fixable by an officer in
 * wp-admin, not by a developer via a commit.
 *
 * @package post165
 */

defined( 'ABSPATH' ) || exit;

const POST165_OPTION         = 'post165_facts';
const POST165_OVERRIDE_ROWS  = 6;

/**
 * Defaults. Every content value is deliberately empty: absent facts omit their
 * row rather than printing a plausible-looking invention.
 */
function post165_default_facts(): array {
	return [
		'eligibility'     => '',
		'dues'            => '',
		'member_count'    => 0,
		'charter_year'    => 1919,
		'meeting_ordinal' => 'first',
		'meeting_weekday' => 'tuesday',
		'meeting_time'    => '18:30',
		'venue'           => '',
		'address'         => '',
		'contact_name'    => '',
		'contact_role'    => '',
		'contact_email'   => '',
		'contact_phone'   => '',
		'overrides'       => [],
		'photos'          => array(),
	];
}

/**
 * Read a single stored fact.
 *
 * @param string $key     Fact key.
 * @param mixed  $default Returned when the stored value is missing.
 * @return mixed
 */
function post165_fact( string $key, $default = '' ) {
	$stored = get_option( POST165_OPTION, [] );
	$facts  = array_merge( post165_default_facts(), is_array( $stored ) ? $stored : [] );

	return array_key_exists( $key, $facts ) ? $facts[ $key ] : $default;
}

/**
 * The standing meeting rule, shaped for post165_meeting_dates().
 */
function post165_meeting_rule(): array {
	return [
		'ordinal' => (string) post165_fact( 'meeting_ordinal', 'first' ),
		'weekday' => (string) post165_fact( 'meeting_weekday', 'tuesday' ),
		'time'    => (string) post165_fact( 'meeting_time', '18:30' ),
		'venue'   => (string) post165_fact( 'venue', '' ),
		'address' => (string) post165_fact( 'address', '' ),
	];
}

/**
 * Per-month override rows, shaped for post165_apply_meeting_overrides().
 */
function post165_meeting_overrides(): array {
	$rows = post165_fact( 'overrides', [] );

	return is_array( $rows ) ? $rows : [];
}

/**
 * Sanitise the whole option on save.
 */
function post165_sanitize_facts( $input ): array {
	$input  = is_array( $input ) ? $input : [];
	$out    = post165_default_facts();

	foreach ( [ 'eligibility', 'dues', 'venue', 'address', 'contact_name', 'contact_role', 'contact_phone' ] as $key ) {
		$out[ $key ] = sanitize_text_field( (string) ( $input[ $key ] ?? '' ) );
	}

	$out['member_count'] = absint( $input['member_count'] ?? 0 );
	$out['charter_year'] = absint( $input['charter_year'] ?? 0 );
	$out['contact_email'] = sanitize_email( (string) ( $input['contact_email'] ?? '' ) );

	$ordinal = strtolower( sanitize_text_field( (string) ( $input['meeting_ordinal'] ?? '' ) ) );
	$out['meeting_ordinal'] = in_array( $ordinal, POST165_ORDINALS, true ) ? $ordinal : 'first';

	$weekday = strtolower( sanitize_text_field( (string) ( $input['meeting_weekday'] ?? '' ) ) );
	$out['meeting_weekday'] = in_array( $weekday, POST165_WEEKDAYS, true ) ? $weekday : 'tuesday';

	$time = sanitize_text_field( (string) ( $input['meeting_time'] ?? '' ) );
	$out['meeting_time'] = preg_match( '/^([01]?\d|2[0-3]):[0-5]\d$/', $time ) ? $time : '18:30';

	$overrides     = [];
	$raw_overrides = is_array( $input['overrides'] ?? null ) ? $input['overrides'] : [];

	foreach ( array_slice( $raw_overrides, 0, POST165_OVERRIDE_ROWS ) as $row ) {
		if ( ! is_array( $row ) ) {
			continue;
		}

		$month = sanitize_text_field( (string) ( $row['month'] ?? '' ) );
		if ( ! preg_match( '/^\d{4}-\d{2}$/', $month ) ) {
			continue;
		}

		$date = sanitize_text_field( (string) ( $row['date'] ?? '' ) );
		$time = sanitize_text_field( (string) ( $row['time'] ?? '' ) );

		$overrides[] = [
			'month'     => $month,
			'date'      => preg_match( '/^\d{4}-\d{2}-\d{2}$/', $date ) ? $date : '',
			'time'      => preg_match( '/^([01]?\d|2[0-3]):[0-5]\d$/', $time ) ? $time : '',
			'venue'     => sanitize_text_field( (string) ( $row['venue'] ?? '' ) ),
			'address'   => sanitize_text_field( (string) ( $row['address'] ?? '' ) ),
			'cancelled' => ! empty( $row['cancelled'] ),
		];
	}

	$out['overrides'] = $overrides;

	$photos     = array();
	$raw_photos = is_array( $input['photos'] ?? null ) ? $input['photos'] : array();

	foreach ( array_slice( $raw_photos, 0, 3 ) as $row ) {
		if ( ! is_array( $row ) ) {
			continue;
		}
		$id = absint( $row['id'] ?? 0 );
		if ( ! $id ) {
			continue;
		}
		$photos[] = array(
			'id'      => $id,
			'caption' => sanitize_text_field( (string) ( $row['caption'] ?? '' ) ),
		);
	}

	$out['photos'] = $photos;

	return $out;
}

/**
 * Photographs chosen for the homepage, newest selection order preserved.
 *
 * @return array<int, array{id:int, caption:string}>
 */
function post165_photos(): array {
	$rows = post165_fact( 'photos', array() );

	return is_array( $rows ) ? $rows : array();
}

/**
 * Register the option.
 */
function post165_register_settings(): void {
	register_setting(
		'post165_settings',
		POST165_OPTION,
		[
			'type'              => 'array',
			'sanitize_callback' => 'post165_sanitize_facts',
			'default'           => post165_default_facts(),
		]
	);
}
add_action( 'admin_init', 'post165_register_settings' );

/**
 * Add the settings page.
 */
function post165_settings_menu(): void {
	add_options_page(
		__( 'Post 165', 'post165' ),
		__( 'Post 165', 'post165' ),
		'manage_options',
		'post165-settings',
		'post165_render_settings_page'
	);
}
add_action( 'admin_menu', 'post165_settings_menu' );

/**
 * Render one text input bound to a fact key.
 */
function post165_settings_field( string $key, string $label, string $type = 'text', string $help = '' ): void {
	$value = post165_fact( $key, '' );
	$name  = POST165_OPTION . '[' . $key . ']';
	$id    = 'post165-' . str_replace( '_', '-', $key );

	printf(
		'<tr><th scope="row"><label for="%1$s">%2$s</label></th><td>'
		. '<input type="%3$s" id="%1$s" name="%4$s" value="%5$s" class="regular-text" />%6$s</td></tr>',
		esc_attr( $id ),
		esc_html( $label ),
		esc_attr( $type ),
		esc_attr( $name ),
		esc_attr( (string) $value ),
		$help ? '<p class="description">' . esc_html( $help ) . '</p>' : ''
	);
}

/**
 * Render a select bound to a fact key.
 */
function post165_settings_select( string $key, string $label, array $choices ): void {
	$value = (string) post165_fact( $key, '' );
	$name  = POST165_OPTION . '[' . $key . ']';
	$id    = 'post165-' . str_replace( '_', '-', $key );

	echo '<tr><th scope="row"><label for="' . esc_attr( $id ) . '">' . esc_html( $label ) . '</label></th><td>';
	echo '<select id="' . esc_attr( $id ) . '" name="' . esc_attr( $name ) . '">';
	foreach ( $choices as $choice ) {
		printf(
			'<option value="%1$s"%2$s>%3$s</option>',
			esc_attr( $choice ),
			selected( $value, $choice, false ),
			esc_html( ucfirst( $choice ) )
		);
	}
	echo '</select></td></tr>';
}

/**
 * The settings screen.
 */
function post165_render_settings_page(): void {
	if ( ! current_user_can( 'manage_options' ) ) {
		return;
	}

	$overrides = post165_meeting_overrides();
	$photos    = post165_photos();
	?>
	<div class="wrap">
		<h1><?php esc_html_e( 'Post 165', 'post165' ); ?></h1>
		<p><?php esc_html_e( 'These values appear on the homepage. Anything left blank is left off the page entirely rather than shown as a placeholder.', 'post165' ); ?></p>

		<form action="options.php" method="post">
			<?php settings_fields( 'post165_settings' ); ?>

			<h2><?php esc_html_e( 'Membership facts', 'post165' ); ?></h2>
			<table class="form-table" role="presentation">
				<?php
				post165_settings_field( 'eligibility', __( 'Who can join', 'post165' ), 'text', __( 'For example: any veteran with honorable service since WWII.', 'post165' ) );
				post165_settings_field( 'dues', __( 'Dues', 'post165' ), 'text', __( 'Written as it should appear, for example "$45 a year".', 'post165' ) );
				post165_settings_field( 'member_count', __( 'Member count', 'post165' ), 'number', __( 'Enter the true number. The site rounds down to the nearest 5 and adds a plus, so it stays accurate as the roster changes.', 'post165' ) );
				post165_settings_field( 'charter_year', __( 'Charter year', 'post165' ), 'number' );
				?>
			</table>

			<h2><?php esc_html_e( 'Meetings', 'post165' ); ?></h2>
			<p><?php esc_html_e( 'Meeting dates are calculated from this rule, so they never need entering by hand.', 'post165' ); ?></p>
			<table class="form-table" role="presentation">
				<?php
				post165_settings_select( 'meeting_ordinal', __( 'Which week', 'post165' ), POST165_ORDINALS );
				post165_settings_select( 'meeting_weekday', __( 'Which day', 'post165' ), POST165_WEEKDAYS );
				post165_settings_field( 'meeting_time', __( 'Start time', 'post165' ), 'time', __( '24-hour clock, for example 18:30.', 'post165' ) );
				post165_settings_field( 'venue', __( 'Venue name', 'post165' ) );
				post165_settings_field( 'address', __( 'Street address', 'post165' ) );
				?>
			</table>

			<h2><?php esc_html_e( 'Changes to individual meetings', 'post165' ); ?></h2>
			<p><?php esc_html_e( 'Use these only when a single meeting differs from the usual rule. Leave a field blank to keep the usual value. A cancelled meeting is left off the homepage.', 'post165' ); ?></p>
			<table class="widefat striped">
				<thead>
					<tr>
						<th scope="col"><?php esc_html_e( 'Month (YYYY-MM)', 'post165' ); ?></th>
						<th scope="col"><?php esc_html_e( 'New date', 'post165' ); ?></th>
						<th scope="col"><?php esc_html_e( 'New time', 'post165' ); ?></th>
						<th scope="col"><?php esc_html_e( 'New venue', 'post165' ); ?></th>
						<th scope="col"><?php esc_html_e( 'Cancelled', 'post165' ); ?></th>
					</tr>
				</thead>
				<tbody>
				<?php for ( $i = 0; $i < POST165_OVERRIDE_ROWS; $i++ ) : ?>
					<?php $row = $overrides[ $i ] ?? []; ?>
					<tr>
						<td><input type="text" placeholder="2026-11" name="<?php echo esc_attr( POST165_OPTION ); ?>[overrides][<?php echo (int) $i; ?>][month]" value="<?php echo esc_attr( $row['month'] ?? '' ); ?>" /></td>
						<td><input type="date" name="<?php echo esc_attr( POST165_OPTION ); ?>[overrides][<?php echo (int) $i; ?>][date]" value="<?php echo esc_attr( $row['date'] ?? '' ); ?>" /></td>
						<td><input type="text" placeholder="19:00" name="<?php echo esc_attr( POST165_OPTION ); ?>[overrides][<?php echo (int) $i; ?>][time]" value="<?php echo esc_attr( $row['time'] ?? '' ); ?>" /></td>
						<td><input type="text" name="<?php echo esc_attr( POST165_OPTION ); ?>[overrides][<?php echo (int) $i; ?>][venue]" value="<?php echo esc_attr( $row['venue'] ?? '' ); ?>" /></td>
						<td><input type="checkbox" value="1" name="<?php echo esc_attr( POST165_OPTION ); ?>[overrides][<?php echo (int) $i; ?>][cancelled]" <?php checked( ! empty( $row['cancelled'] ) ); ?> /></td>
					</tr>
				<?php endfor; ?>
				</tbody>
			</table>

			<h2><?php esc_html_e( 'Who to contact', 'post165' ); ?></h2>
			<table class="form-table" role="presentation">
				<?php
				post165_settings_field( 'contact_name', __( 'Name', 'post165' ) );
				post165_settings_field( 'contact_role', __( 'Role', 'post165' ), 'text', __( 'For example: Membership.', 'post165' ) );
				post165_settings_field( 'contact_email', __( 'Email', 'post165' ), 'email' );
				post165_settings_field( 'contact_phone', __( 'Phone', 'post165' ) );
				?>
			</table>

			<h2><?php esc_html_e( 'Photographs', 'post165' ); ?></h2>
			<p><?php esc_html_e( 'Choose up to three photographs for the homepage. The attachment ID is the value that is actually saved; the picker button is a convenience for finding it.', 'post165' ); ?></p>
			<table class="widefat striped">
				<thead>
					<tr>
						<th scope="col"><?php esc_html_e( 'Attachment ID', 'post165' ); ?></th>
						<th scope="col"><?php esc_html_e( 'Caption', 'post165' ); ?></th>
						<th scope="col"><?php esc_html_e( 'Picker', 'post165' ); ?></th>
					</tr>
				</thead>
				<tbody>
				<?php for ( $i = 0; $i < 3; $i++ ) : ?>
					<?php $row = $photos[ $i ] ?? []; ?>
					<tr>
						<td><input type="number" class="post165-pick-id" name="<?php echo esc_attr( POST165_OPTION ); ?>[photos][<?php echo (int) $i; ?>][id]" value="<?php echo esc_attr( (string) ( $row['id'] ?? '' ) ); ?>" /></td>
						<td><input type="text" name="<?php echo esc_attr( POST165_OPTION ); ?>[photos][<?php echo (int) $i; ?>][caption]" value="<?php echo esc_attr( $row['caption'] ?? '' ); ?>" class="regular-text" /></td>
						<td>
							<button type="button" class="button post165-pick"><?php esc_html_e( 'Choose', 'post165' ); ?></button>
							<img src="<?php echo ! empty( $row['id'] ) ? esc_url( (string) wp_get_attachment_image_url( (int) $row['id'], 'thumbnail' ) ) : ''; ?>" class="post165-pick-preview" style="max-width:80px;height:auto;margin-left:8px;vertical-align:middle;<?php echo empty( $row['id'] ) ? 'display:none;' : ''; ?>" alt="" />
						</td>
					</tr>
				<?php endfor; ?>
				</tbody>
			</table>

			<?php submit_button(); ?>
		</form>
	</div>
	<?php
}

/**
 * Enqueue the media modal on the Post 165 settings screen only.
 */
function post165_settings_assets( $hook ): void {
	if ( 'settings_page_post165-settings' !== $hook ) {
		return;
	}

	wp_enqueue_media();
	wp_add_inline_script( 'jquery-core', "
jQuery(function($){
  $('.post165-pick').on('click', function(e){
    e.preventDefault();
    var row = $(this).closest('tr');
    var frame = wp.media({ title: 'Choose a photograph', multiple: false });
    frame.on('select', function(){
      var a = frame.state().get('selection').first().toJSON();
      row.find('.post165-pick-id').val(a.id);
      row.find('.post165-pick-preview').attr('src', (a.sizes && a.sizes.thumbnail ? a.sizes.thumbnail.url : a.url)).show();
    });
    frame.open();
  });
});
" );
}
add_action( 'admin_enqueue_scripts', 'post165_settings_assets' );
