
When ("the user removes that product") do
    click_link "Remove"
end

Then ("the user should see product removed") do
    expect(page).not_to have_content(@product.price)
end