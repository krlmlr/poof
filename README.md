
<!-- README.md is generated from README.Rmd. Please edit that file -->

# poof

RStudio addins are great but have flaws :

-   They’re contained in packages, which are not straightforward to
    write/iterate on
-   It’s hard to remember which addins you’ve installed, and harder to
    remember the hotkeys you’ve set for them
-   The addin list soon becomes overwhelming

So you don’t write them much, and you don’t use them much.

{poof} is an attempt to solve those issues:

-   It works with a single hotkey
-   Depending on your selection (or current line or document), only
    relevant action choices are proposed
-   It’s made very easy to add actions

We don’t recommend attaching the package, a call to `poof::add_tricks()`
in your R profile is all you should need.

## Installation

``` r
remotes::install_github("moodymudskipper/poof")
```

## general

We call “tricks” the features implemented by {poof}, and use the
following syntax to define them :

``` r
poof::add_tricks("<label1>" = <condition1> ~ <action1>, "<label2>" = <condition2> ~ <action2>, ...)
```

-   When the **hotkey** is triggered , all **conditions** are evaluated
-   When the **condition** is satisfied, the **label** of the trick is
    is shown
-   When the **label** is selected, the **action** is triggered

The package contains a suit of functions to help you define actions and
conditions conveniently.

Let’s go through a few examples.

## Editing your R Profile

Do you know how to easily edit your user or project R Profile ? There’s
a nice {usethis} function for this, but maybe you have problems
remembering it, or you’d rather not have to type it.

We propose below tricks to do that. If you trigger {poof} when not
selecting anything in the editor it will propose you to edit either your
user or project R profile.

``` r
poof::add_tricks(
  "Edit user '.Rprofile'" =
    selection_is_empty() ~     # condition : no selection
    usethis::edit_r_profile(), # action    : call packaged function

  "Edit project '.Rprofile'" =
    selection_is_empty() ~                      # condition : no selection
    usethis::edit_r_profile(scope = "project"), # action    : call packaged function
)
```

We see below that whenever the selection is not empty the labels are not
shown, but they are shown if the selection is empty.

*INSERT GIF*

Setting up tricks when the selection is empty is a good way to keep a
list of bookmarks for actions you don’t want to remember how to trigger,
maybe some other {usethis} workflow actions.

`selection_is_empty()` is called a **condition helper**, and we have
many of them, documented in :

-   \`?\`\`selection-condition-helpers\`\`\`
-   \`?\`\`file-condition-helpers\`\`\`
-   \`?\`\`project-condition-helpers\`\`\`
-   \`?\`\`clipboard-condition-helpers\`\`\`
-   \`?\`\`system-condition-helpers\`\`\`

## Reprex your selection

The {reprex} package comes with a handy addin to create a reprex from a
hotkey. You’ll have to remember how to trigger the hotkey though.

If you don’t want to we can set up a trick that will be proposed
whenever we select parsable code that isn’t a symbol, when it is
triggered it should call the relevant {reprex} addin.

``` r
poof::add_tricks(
  "Reprex selection" =
    selection_is_parsable(symbol_ok = FALSE) ~  # condition : selection is code
    call_addin("reprex", "Reprex selection"),   # action    : call existing addin
)
```

We see below that whenever the selected code is parsable and is more
than just a symbol, the action will be proposed.

*INSERT GIF*

`selection_is_parsable()` is another **condition helper**.
`call_addin()` is an **action helper**, there are more of them
documented in \`?\`\`action-helpers\`\`\`.

It is good practice to have narrow conditions around our use cases so as
our list of tricks grows we only display those that apply. We could have
defined
`poof::add_tricks("Reprex selection" = TRUE ~ call_addin("reprex", "Reprex selection"))`
but then Reprex Selection would always be proposed even when it doesn’t
apply.

## `debugonce()`

You might not like to type the name of a function when you want to
debug, we might could define an addin to call `debugonce()` on your
selection but then you have to find an unused hotkey and remember it.

We can set a trick to `debugonce()` a function, it should be proposed
only if the selection is a symbol bound to a function.

``` r
poof::add_tricks(
  # label : here using glue syntax to have dynamic action names
  "debugonce({current_selection()})" = 
    # condition : selection evaluates to function
    selection_is_function() ~ 
    # action    : run debugonce, we use `bquote()`'s `.()` notation to work around NSE issues
    debugonce(.(current_call())),      
)
```

We see below that the action is proposed only if a symbol is selected
and evaluates to a function.

**INSERT GIF**

`selection_is_function()` is another **condition helper**.
`current_selection()` and `current_call()` are **context informers**,
they are documented in `?current_selection`.

We note a couple new things here : \* We used {glue} notation in the
label, this is handy to provide custom labels \* We used `.()` inside
`debugonce()`, this is the same `.()` that we find in `bquote()`,
`debugonce()` uses NSE and supporting `.()` in actions and conditions
permit us to program with such functions conveniently.

## Where are these tricks stored ? Can I remove some ?

They’re stored in the `"poof.tricks"` option which you can display with
`getOption("poof.tricks")` or `poof::show_tricks()`. You can remove
tricks by calling `poof::rm_tricks()` with the labels of the tricks to
remove.

## Isn’t it slow to have a lot of tricks ? Is it safe ?

All of the helper functions are memoised so they will only be called
once, and results will stay in memory while other conditions are
evaluated. Given that most of these operations are pretty quick to begin
with it’s unlikely that you’ll witness big lags. However if you push it
you might succeed to design conditions that do take non trivial time to
evaluate.

We discourage evaluating the selection (unless it’s a symbol) by
forbidding the use of `current_value()` in conditions. Evaluating a
complex expression might take time and/or have side effects and this
would really spoil the fun of {poof}. Unless you try really hard,
conditions won’t affect the global state so {poof} can be used safely.

Moreover condition cannot trigger an error, if its code fails it just
returns `FALSE`, the evaluation of conditions is also totally silent.

## Use packages of tricks or design your own

`poof::add_tricks()` can take named formulas as arguments as we’ve seen
above. It can also take `"trick"` objects.

`"trick"` objects are created using the `new_trick()` function and they
can be fed as unnamed arguments.

If we want to package the first trick we defined in this document we
might create a package {mytricks} and have :

``` r
#' Edit user R Profile
#' 
#' A trick that proposes edit the user R profile
#'@export
#'@name edit_user_rprofile
edit_user_rprofile <- poof::new_trick(
  "Edit user '.Rprofile'",
  ~ selection_is_empty(),
  ~ usethis::edit_r_profile()
)
```

And then tricks can be added this way

``` r
poof::add_trick(
  my.trick.pkg::edit_user_rprofile,
)
```
