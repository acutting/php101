<?php

require '../includes/form.php';

$form_fields = array('username', 'password');
$required_fields = array('username', 'password');

$form = form_get_data($form_fields, $_POST);
$valid = form_is_valid($form, $required_fields);

?>
<!DOCTYPE html>
<html>
    <head>
        <title>Login</title>
    </head>
    <body>
        <pre><?php var_dump($form); ?></pre>
        <?php if ($valid) {
            ?>
            <div>
                This form is valid!!
            </div>
            <?php
        } ?>
        <form method="post">
            <ul>
                <li>
                    <label for="username">Username</label>
                    <input type="text" name="username" value="<?php echo htmlentities($form['username']); ?>" />
                </li>
                <li>
                    <label for="password">Password</label>
                    <input type="password" name="password" />
                </li>
                <li>
                    <input type="submit" value="Submit" />
                </li>
            </ul>
        </form>
    </body>
</html>