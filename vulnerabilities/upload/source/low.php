<?php

if( isset( $_POST[ 'Upload' ] ) ) {
	$target_path = DVWA_WEB_PAGE_TO_ROOT . "hackable/uploads/";
	$target_path .= basename( $_FILES[ 'uploaded' ][ 'name' ] );

	$allowed_types = [ 'image/jpeg', 'image/png', 'image/gif' ];
	$file_info     = getimagesize( $_FILES[ 'uploaded' ][ 'tmp_name' ] );

	if( $file_info === false || !in_array( $file_info[ 'mime' ], $allowed_types, true ) ) {
		$html .= '<pre>Upload rejected: file is not a valid image.</pre>';
	}
	elseif( !move_uploaded_file( $_FILES[ 'uploaded' ][ 'tmp_name' ], $target_path ) ) {
		$html .= '<pre>Your image was not uploaded.</pre>';
	}
	else {
		$html .= "<pre>{$target_path} succesfully uploaded!</pre>";
	}
}

?>
