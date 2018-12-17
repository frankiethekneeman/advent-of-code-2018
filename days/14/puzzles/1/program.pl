my @recipes = (3,7);
my $elf1 = 0;
my $elf2 = 1;
my $needed = <STDIN>;
chomp($needed);
$needed += 10;
sub getNewRecipes {
    use List::Util qw(sum);
    my $sum = sum(@_);
    return split(//, "$sum");
}

sub walk{
    my $elf = @_[0];
    my @distances = @{ @_[1] };
    my $l = @distances;
    return($elf + @distances[$elf] + 1) % $l;
}

while (@recipes < $needed) {
    @newRecipes = getNewRecipes(@recipes[$elf1],@recipes[$elf2]); 
    push(@recipes, @newRecipes);
    $elf1 = walk($elf1, \@recipes);
    $elf2 = walk($elf2, \@recipes);
}

print @recipes[($needed-10)..($needed-1)], "\n";
